From: Tao Ma <tm@tao.ma>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 19:13:52 +0800
Message-ID: <510BA370.1040309@tao.ma>
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org> <510B904B.4050508@redhat.com> <510B9213.1040508@tao.ma> <510B93EE.8000304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510B93EE.8000304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2013 06:07 PM, Bryn M. Reeves wrote:
> On 02/01/2013 09:59 AM, Tao Ma wrote:
>> yes, but the result is the same. It will do some IO first which will
>> cause this command hang.
> 
> You seem to have a problem with either the device/adapter or in the
> driver. The backtrace you posted shows that jbd2 (ext4) is still waiting
> on IO that's been submitted to an mpt2sas or mpt3sas adapter (I only
> know that because I recognise their log messages - you should try to
> include relevant details like this when seeking assistance).
This should be  a mpt2sas adapter
#lsmod|grep mpt
mptctl                 96789  0
mptbase                97052  1 mptctl
mpt2sas               164962  18
scsi_transport_sas     35232  3 isci,libsas,mpt2sas
raid_class              4746  1 mpt2sas

The system has 12 sata disks. What else do you need? I am willing to
provide any details you want.

> 
> The adapter/driver hasn't completed the IO and it looks like the SCSI
> layer is trying to abort it. Depending on the state of the driver and
> hardware your only option might be to reboot (or physically hot remove
> the device if your hardware allows it).
OK, so let me describe the situation here. This is one of our storage
system. So 12 2TB sata disk in one box, normally when one disk fails, we
just want to remove it from the system by *software*, and then continue
to use the 11 disks left. We have found that sometimes an unsuccessful
umount or some actions against this disk can lead to some bad
situation(Say some very high load because many processes are 'D'ed). So
ideally if we can remove this device successfully, all the ios to this
disk will fail and there will be no 'D' processes and the loadavg will
also be low.
> 
> You don't mention the versions of the kernel and driver you're using -
> if the system is in production I would suggest contacting who ever
> normally provides support for the kernel and distribution that you are
> running.
We use CentOS6.2 and the kernel version is 2.6.32-220.23.1.

Thanks,
Tao
