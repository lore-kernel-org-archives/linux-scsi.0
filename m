From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Mon, 01 Oct 2007 11:00:44 -0700
Message-ID: <470135CC.4080101@qlogic.com>
References: <46F3D66A.9010000@qlogic.com>	<20070923231416K.tomof@acm.org>	<46FBBF8C.80409@qlogic.com> <20070929151608P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39452 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXJASBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 14:01:16 -0400
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
> 
> 1. scsi-misc + the qla2xxx target patch
> 
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
Above command execution on the system with the HBA with target mode returns "invalid request" for some reason.
Not sure if there are any steps that has to be in place?

The configuration is as follow,
- two systems + a switch + a target device (JBOD) are involved.
- each of systems has a QLogic HBA in it. The HBA on one system is in initiator mode and the other one is in target mode.
- each of the port of the HBAs is connected to the switch and a target device (JBOD) is connected to the switch, too.

Thank you,
Seokmann
---
atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # tgtadm --lld fc --mode target --op show
Target 1: volume1
    System information:
        Driver: fc
        Status: running
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: deadbeaf1:0
            SCSI SN: beaf10
            Size: 0
            Online: No
            Poweron/Reset: Yes
            Removable media: No
            Backing store: No backing store
    ACL information:
atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # lsmod
Module                  Size  Used by
qla2xxx               173672  0 
ipv6                  254244  14 
snd_pcm_oss            50560  0 
snd_mixer_oss          20224  1 snd_pcm_oss
snd_seq                55152  0 
snd_seq_device         12556  1 snd_seq
loop                   21252  0 
dm_mod                 56768  0 
snd_hda_intel         280092  0 
snd_pcm                82436  2 snd_pcm_oss,snd_hda_intel
snd_timer              26244  2 snd_seq,snd_pcm
snd                    58628  7 snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
soundcore              11744  1 snd
snd_page_alloc         14088  2 snd_hda_intel,snd_pcm
parport_pc             41956  1 
lp                     15396  0 
parport                38344  2 parport_pc,lp
reiserfs              223744  1 
edd                    13124  0 
firmware_class         13696  1 qla2xxx
sg                     37404  0 
scsi_transport_fc      45444  1 qla2xxx
sd_mod                 31616  3 
scsi_tgt               18504  3 qla2xxx,scsi_transport_fc
sr_mod                 19620  0 
cdrom                  36896  1 sr_mod
ata_piix               20356  2 
atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # uname -r
2.6.23-rc3-smp-tgt
---
