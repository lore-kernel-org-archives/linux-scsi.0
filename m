From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Sun, 30 Sep 2007 03:57:07 -0700
Message-ID: <46FF8103.5090502@qlogic.com>
References: <46F3D66A.9010000@qlogic.com>	<20070923231416K.tomof@acm.org>	<46FBBF8C.80409@qlogic.com> <20070929151608P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:5955 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXI3K5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 06:57:40 -0400
In-Reply-To: <20070929151608P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de

FUJITA Tomonori wrote:
> On Thu, 27 Sep 2007 07:34:52 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Fri, 21 Sep 2007 07:34:18 -0700
>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>
>>>> Andrew Vasquez wrote:
>>>>> On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
>>>>>
>>>>>> This adds target mode support to qla2xxx.
>>>>>>
>>>>>> With set ql2enable_target_mode module parameter to 1, the driver runs
>>>>>> in target mode. By default, ql2enable_target_mode is set to 0, and the
>>>>>> driver should work in initiator mode as before.
>>>>>>
>>>>>> The driver could support dual-mode in the future but it doesn't at the
>>>>>> moment (we need to add dual-mode support tgt first).
>>>>>>
>>>>>> It is based on scst qla2xxx target mode driver. Mike converted the
>>>>>> driver to use tgt long ago. I changed it to use the latest (mainline)
>>>>>> version of qla2xxx driver and tgt, and also converted it to use fc
>>>>>> transport class.
>>>>> Thanks for doing this.  Some initial comments before a full review is
>>>>> complete, As was seen from the initiator updates needed for 24xx
>>>>> support, there are comparable changes needed in the area of
>>>>> target-mode support for 4gb and 8gb parts.  Also, which ISPs and
>>>>> firmwares were exercised with this code?
>>>> The patch is still under reviewing and will get done, soon.
>>> Great, thinks!
>> One more question on typical testing setup.
>> I wonder how should I setup the testing environment esp., for the
>> target-mode.
> 
> Sorry, I should have explained it with the patch.
>
> Probabaly, you need to compile scsi-misc with the qla2xxx target patch
> and the user-space target code.
Thank you, I will make it.

> 1. scsi-misc + the qla2xxx target patch
Just for the future references, should I expect same effect from following repository?
git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-target.git

> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_QLA_FC=m
> CONFIG_SCSI_QLA_FC_TGT=y
> 
> 2. the user-space target code
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/tgt.git
> 
> rouen:~/git/tgt/usr$ make FCP=1 KERNELSRC=/home/fujita/git/scsi-misc-2.6
> 
> 
> Starting the fc target mode is not so simple now (Mike and I know that
> we need to fix it...).
> 
> 1. load scsi_tgt.ko
> 
> 2. start the user-space daemon
> 
> Here's a simple example.
> 
> ./tgt/usr/tgtd
> ./tgt/usr/tgtadm --lld fc --mode target --op new --tid 1 --targetname volume1
> ./tgt/usr/tgtadm --lld fc --mode logicalunit --op new --tid 1 --lun 1 -b /var/tmp/lun1
> ./tgt/usr/tgtadm --lld fc --mode target --op bind --tid 1 --host 2
> 
> You use a /var/tmp/lun1 file as #1 logical unit. The host number must
> be equal to qla2xxx scsi host number (when you load qla2xxx module).
> 
> Then load scsi_transport_fc.ko and qla2xxx.ko (please don't forget
> ql2enable_target_mode=1 option).
> 
> You can make sure everything is fine by the following command:
> 
> luce:/home/fujita# cat /sys/class/scsi_host/host2/model_name
> QLA2340
> luce:/home/fujita# cat /sys/class/scsi_host/host2/active_mode
> Target
> 
> luce:/home/fujita# ./tgt/usr/tgtadm --lld fc --mode target --op show
> Target 1: volume1
>     System information:
>         Driver: fc
>         Status: running
>     I_T nexus information:
>     LUN information:
>         LUN: 0
>             Type: controller
>             SCSI ID: deadbeaf1:0
>             SCSI SN: beaf10
>             Size: 0
>             Online: No
>             Poweron/Reset: Yes
>             Removable media: No
>             Backing store: No backing store
>         LUN: 1
>             Type: disk
>             SCSI ID: deadbeaf1:1
>             SCSI SN: beaf11
>             Size: 1G
>             Online: Yes
>             Poweron/Reset: No
>             Removable media: No
>             Backing store: /var/tmp/lun1
>     ACL information:
> 
> 
> 
>> If you have, could you share the details of the layout of the
>> environment that you have had used for the feature verification?
> 
> I use two hosts with qla23xx and a host with lpfc, which are connected
> via Brocade SilkWorm. One of qla23xx host runs in target mode. Another
> qla23xx host and the lpfc host can connect to the qla23xx target host.
> 
> 
> Here's lsscsi output in the lpfc host. The qla23xx target host gives
> [13:0:0:0] and [13:0:0:1] (yeah, I know, IET vendor name is strange).
> 
> lily:/home/fujita# lsscsi
> [0:0:0:0]    disk    ServeRA  Drive 1          V1.0  /dev/sda
> [0:0:1:0]    disk    ServeRA  Drive 2          V1.0  /dev/sdb
> [0:1:0:0]    disk    IBM-ESXS GNA300C3ESTT0Z N BH0G  -
> [0:1:1:0]    disk    IBM-ESXS GNA300C3ESTT0Z N BH0G  -
> [0:3:0:0]    enclosu IBM      SAS SES-2 DEVICE 1.06  -
> [13:0:0:0]   storage IET      Controller       0001  -
> [13:0:0:1]   disk    IET      VIRTUAL-DISK     0001  /dev/sdc
> [13:0:1:0]   disk    IBM      1814      FAStT  2916  /dev/sdd
> [13:0:1:1]   disk    IBM      1814      FAStT  2916  /dev/sde
> [13:0:1:31]  disk    IBM      Universal Xport  2916  -
> [13:0:2:0]   disk    IBM      1814      FAStT  2916  /dev/sdf
> [13:0:2:1]   disk    IBM      1814      FAStT  2916  /dev/sdg
> [13:0:2:31]  disk    IBM      Universal Xport  2916  -
I appreciate you for the details and will get back to you as I make progress.

Seokmann

