From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: failover does not work with rdac device handler
Date: Fri, 3 Oct 2008 21:35:16 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>,
	<1223081419.14830.585.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1223081419.14830.585.camel@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Chandra for the response..

That is the good news. So, we do not have to change the kernel  code ever=
ytime we want to support the new product.

I will do the steps you mentioned first thing on Monday and reply your ba=
ck.

Thanks
Babu Moger

________________________________________
From: Chandra Seetharaman [sekharan@us.ibm.com]
Sent: Friday, October 03, 2008 7:50 PM
To: Moger, Babu
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] failover does not work with rdac device handler

It is supposed to work. I will look into it and respond.

Can you try one thing

for all your devices, do
        echo rdac > /sys/block/sd?/dh_state

(first you can read the files and see if they all show rdac or not)

and then do your fail over. Let me know what happens.

chandra
On Fri, 2008-10-03 at 18:12 -0600, Moger, Babu wrote:
> Hi,
>
> I have quick question.
>
> I am trying to configure device mapper for my FC array (on my Linux box=
). I have passed all the arguments from /etc/multipath.conf(like vendor, =
model etc ..).
>
> Discovery seems fine. But, failover is not working.  I am seeing the fo=
llowing error.
>
> "device-mapper: multipath: Cannot failover device because scsi_dh_rdac =
was not loaded."
>
> Is it required to add vendor id and model id anywhere else to support t=
his device?
>
> Thanks
> Babu Moger
>
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Moger, Babu
> Sent: Wednesday, October 01, 2008 4:48 PM
> To: device-mapper development; linux-scsi@vger.kernel.org
> Subject: [dm-devel] failover does not work with rdac device handler
>
> Hi All,
>
> I am new to the device mapper and just thought I will set-up device map=
per on our arrays. I am using the latest kernel 2.6.27.rc6 and got the la=
test multipath-tools from upstream.
>
> I updated /etc/multipath.conf with all the information (vendor, product=
, hardware_handler, prio etc  ...). Note that my device is not part of rd=
ac_dev_list.
>
> Discovery worked fine. "multipath -ll" displays all the information. I =
can see that it is picking up rdac device handler.
>
> But I found that for some reason failover/failback is not working.  I a=
m seeing following these messages.
>
> "device-mapper: multipath: Cannot failover device because scsi_dh_rdac =
was not loaded."
>
> I can see that scsi_dh_rdac driver is already loaded.
>
> I did some more investigation. Found that failover works fine if I add =
vendor, model in rdac_dev_list (in file scsi_dh_rdac.c).
>
> My question - is it required to add all the supported vendor and model =
names in rdac_dev_list?
>
> Appreciate your responses.
>
> Thanks
> Babu Moger
>
>
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
