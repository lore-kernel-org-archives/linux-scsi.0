From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: iscsi target kernel error log support
Date: Sat, 29 Oct 2016 16:58:03 -0700
Message-ID: <1477785483.22703.92.camel@haakon3.risingtidesystems.com>
References: <VI1PR0701MB2783907515D67321D0628FD19AD30@VI1PR0701MB2783.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0701MB2783907515D67321D0628FD19AD30@VI1PR0701MB2783.eurprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "Jin, Ke (Nokia - CN/Hangzhou)" <ke.jin@nokia.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Xiong, Li (Nokia - CN/Hangzhou)" <li.xiong@nokia.com>, Tom Herbert <tom@herbertland.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jin,

Adding Tom CC' for SO_REUSEPORT and Andy CC' for INADDR_ANY + targetcli.

On Tue, 2016-10-18 at 01:25 +0000, Jin, Ke (Nokia - CN/Hangzhou) wrote:
> Hi,
> Sorry to disturb you.
>  
> I am using targetcli to configure the iscsi target on my linux host. I
> find one issue, could you kindly review it and give some comments to
> me.
>  
> Issue: (linux kernel 4.4 stable)
>  
> Configure first target:
> 10/14/16 17:07:00.538417942: targetcli /iscsi create iqn.2016-08.nokia.lab:chu-0
> Created target iqn.2016-08.nokia.lab:chu-0.
> Created TPG 1.
> Global pref auto_add_default_portal=true
> Created default portal listening on all IPs (0.0.0.0), port 3260.
> 10/14/16 17:07:00.650688229: targetcli /backstores/block create iblock_0 dev=/dev/sda
> Created block storage object iblock_0 using /dev/sda.
> 10/14/16 17:07:00.772435404: targetcli /iscsi/iqn.2016-08.nokia.lab:chu-0/tpg1/luns create /backstores/block/iblock_0 1
> Created LUN 1.
> 10/14/16 17:07:00.894355883: targetcli /iscsi/iqn.2016-08.nokia.lab:chu-0/tpg1/portals delete 0.0.0.0 3260
> Deleted network portal 0.0.0.0:3260
> 10/14/16 17:07:01.012410786: targetcli /iscsi/iqn.2016-08.nokia.lab:chu-0/tpg1/portals create 10.180.180.111
> Using default IP port 3260
> Created network portal 10.180.180.111:3260.
> 10/14/16 17:07:01.130478681: targetcli /iscsi/iqn.2016-08.nokia.lab:chu-0/tpg1/acls create iqn.2016-08.nokia.lab:initiator.chu-0-0
> Created Node ACL for iqn.2016-08.nokia.lab:initiator.chu-0-0
> Created mapped LUN 1.
>  
> Then I configure second target on same host.
> targetcli /iscsi create iqn.2016-08.nokia.lab:omu-0
> Created target iqn.2016-08.nokia.lab:omu.
> Created TPG 1.
> Default portal not created, TPGs within a target cannot share ip:port.
> Then I check the kernel log with dmesg, there is one error log
> “kernel_bind() failed: -98”.
>  
>  

So AFAIK, the failure of INADDR_ANY portal binding when !INADDR_ANY
portals exist was the original expected behavior.

>  
> Then I begin to check the iscsi kernel module code. linux-stable
> \drivers\target\iscsi\ iscsi_target_login.c
> int iscsit_setup_np()
> {
>         ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, 
>                         (char *)&opt, sizeof(opt));
> }
> I think SO_REUSEADDR is not enough in this case (there have two
> targets configured), when targetcli /iscsi create
> iqn.2016-08.nokia.lab:omu-0, it will create listening socket with
> 0,0,0,0:3260, because it already have 10.180.180.111:3260 listening
> sockets there in first target, so this cause the kernel_bind() failed:
> -98”. So I add SO_REUSEPORT also. It works.
> int iscsit_setup_np()
> {
>         ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, 
>                         (char *)&opt, sizeof(opt));
>         ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEPORT,
>                         (char *)&opt, sizeof(opt));
> }
>  
> How do you think, do you think this is the kernel bug or just my
> configuration issue, or you already have this patch?
>  

At iscsi-target application level, we're using a iscsi_np kthread
listener per ipv4 / ipv6 addr + port. (eg: one listener per iscsi
network portal)

The network portal can be shared across N target endpoints
in /sys/kernel/config/target/iscsi/$IQN/$TPGT/np/*, but the actual
listening + accept for each ipv4 / ipv6 addr + port is still done from a
single kthread context.

So AFAICT for your use-case, adding SO_REUSEPORT to allow concurrent
INADDR_ANY + !INADDR_ANY network portals should be OK, at least from an
iscsi-target perspective.

That is, iscsi-target would consider each as a separate network portal,
allowing INADDR_ANY + !INADDR_ANY accepts to be serviced across multiple
iscsi_np kthreads.

There should not be an inherent issue allowing this, but it would useful
to understand if there are any other possible ramifications before
enabling by default.
