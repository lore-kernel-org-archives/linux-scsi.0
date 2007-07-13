From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: Re: [dm-devel] dm-mpath-rdac.patch problem
Date: Fri, 13 Jul 2007 12:33:03 -0700
Message-ID: <4697D36F.5030201@csupomona.edu>
References: <4696D6CB.6050504@csupomona.edu><1184292400.5146.45.camel@linuxchandra><20070713023743.GA5350@us.ibm.com> <20070713161253.GA20901@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sparky.unx.csupomona.edu ([134.71.247.19]:53172 "EHLO
	sparky.unx.csupomona.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194AbXGMTdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 15:33:07 -0400
In-Reply-To: <20070713161253.GA20901@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org

Andrew Vasquez wrote:
> On Thu, 12 Jul 2007, Mike Anderson wrote:
> 
>> Copying this mail to linux-scsi and Ccing Andrew Vasquez to possibly
>> provide input on the Qlogic behavior.
>>
>> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
>>> On Thu, 2007-07-12 at 18:35 -0700, Brian De Wolf wrote:
>>>> Hello All,
>>>>
>>>> I'm not sure if this is the right place for this, but it seems to be the only
>>>> mailing list related to dm, multipath, and rdac, as far as I can tell.  I've
>>>> been trying out the dm-mpath-rdac patch (both yesterday's and previous) with
>>>> gentoo's unstable 2.6.22 kernel, on a Sun x4100 through a QLA2422 HBA (firmware
>>>> ql2400_fw.bin.4.00.27) to an IBM DS4000.  I am using a version of
>>>> multipath-tools that I got with git a few days ago.
>>>>
>>>> I've got multipath working, it reports the hwhandler correctly ([hwhandler=1
>>>> rdac]), and the volume is mountable, etc.  It also shows one link as active, the
>>>> other as ghost.  However, once the active link dies, the volume becomes read
>>>> only, and both connections are listed as failed.  Most importantly, something
>>>> like this shows up in the logs:
>>>>
>>>> Jul 12 17:11:15 jimbo kernel: device-mapper: multipath rdac: queueing
>>>> MODE_SELECT command on 8:32
>>> It does look like the rdac hardware handler is doing the right thing and
>>> the qlogic is dying for some reason.
>>>
>>> I have tested this code in both RHEL5 and SLES10 environments (qla23xx)
>>> and they work fine. Can you try in one of those and see if it is any
>>> different.
>>>
>>> Just an FYI w.r.t multipath tools: please remove the patch
>>> http://git.kernel.org/?p=linux/storage/multipath-
>>> tools/.git;a=commit;h=e1e1a1bfb2cf76bfd1a49335e3deec5360fb09db from your
>>> tree for the tools to calculate the path priorities properly.
>>>
>>>
>>>> Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
>>>> mbx2=8012h mbx3=8002h.
>>>> Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
>>>> dumped (ffffc2000171d000) -- ignoring request...
>>>> Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
>>>> recovery - ha= ffff81007e85c530.
> 
> Hmm yes, there's some real problems going on within the firmware which
> we need to triage.  From the snippet above, the driver was able to
> capture a firmware-dump of a failure (not sure of the timing and how
> it relates to the window in which you recognized a 'problem'), but
> I'll need to to 'capture' the firmware trace and forward it along to
> us to inspect.
> 
> 1) download the following shell script:
> 
> 	ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/test/qla_dmp.sh
> 
> 2) copy the script to the host (/tmp) which is experiencing the
>    problems.
> 
> 3) reboot and load the driver with the ql2xextended_error_logging
>    module parameter set to 1. e.g.:
> 
> 	$ insmod qla2xxx.ko ql2xextended_error_logging=1
> 
> 4) rerun your test and monitor the kernel-messages file for a message
>    similar to:
> 
>         Firmware dump saved to temp buffer (1/adcdabcd)
> 
> 5) To retrieve the dump, go to a console and type the following:
> 
>         # cd /tmp/
>         # ./qla_dmp.sh 1
> 
>    The value passed to qla_dmp.sh should be the same as the first integer
>    in the 'saved to temp buffer' string (in this example, 1).  If the
>    operation was successful, a message like to following should be
>    displayed:
> 
>         Firmware dumped to file fw_dump_1_20041217_023222.txt.gz
> 
>    Formward the 
>    forward over the file.
> 
> 6) forward over the /var/log/messages file of the driver load and
>    failure snippet.
> 
> 
> Not sure which firmware version you are running, but an additional
> datapoint which may be useful after you send the firmware-dump is to
> download the latest 24xx firmware file from QLogic.com:
> 
> 	ftp://ftp.qlogic.com/outgoing/linux/firmware/ql2400_fw.bin
> 
> and retry the test.  If you still see problems, and see a similar
> 'Firmware dump saved...' messages.  Follow the steps above again and
> forward the same datapoints.
> 

I have tried both the ql2400_fw.bin.4.00.18 and ql2400_fw.bin.4.00.27 firmwares
and the HBA had the same error.  The attached datapoints were done using
ql2400_fw.bin.4.00.27.

Note:  This is a resend to the mailing list without attachments.

>>>> While this may be something for the maintainer of the qla2xxx module (I can't
>>>> figure out where I'd send it, in that case...) I think it may be of interest
>>>> that the dm_rdac module tries to push something over the HBA that causes it to
>>>> bail completely and start from scratch (it starts init processes and loading
>>>> firmware again).
>>>>
>>>> Not to say that I'm not interested in any help getting this working, that is.
>>>> If you have any suggestions on how to get this working, I'd love to hear them.
>>>> I'm also willing to guinea pig some testing if you need it (This box still has a
>>>> bit before it will have to be put in use).  I may use redhat to ensure that it's
>>>> not just a broken HBA, but for the long run we would like it to join our gentoo
>>>> environment.
>>>>
>>>> Thanks!
>>>> Brian De Wolf
>>>>
>>>> PS- If the subject mislead you because you feel that this is just a qla2xxx
>>>> problem, I'm sorry for wasting your time.
> 
> Regards,
> Andrew Vasquez
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

