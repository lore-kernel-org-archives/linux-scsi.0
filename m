From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and iSCSI Target
 Stack on v2.6.27-rc7
Date: Thu, 02 Oct 2008 21:00:47 +0400
Message-ID: <48E4FE3F.2080707@vlnb.net>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>	<48E3B529.4060406@vlnb.net> <1222907050.15764.56.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:56444 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755224AbYJBRAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 13:00:52 -0400
In-Reply-To: <1222907050.15764.56.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

Nicholas A. Bellinger wrote:
>>> # Add some more HBA and storage Objects
>>> target:~# mkdir -p $TARGET/fileio_0/file_object
>>> target:~# mkdir -p $TARGET/rd_mcp_0/ramdisk0
>>> target:~# mkdir -p $TARGET/rd_dr_0/ramdisk0
>>>
>>> target:~# mkdir -p $TARGET/pscsi_0/sdd
>>> target:~# echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/dev_control   
>>> target:~# echo 1 > $TARGET/pscsi_0/sdd/dev_enable 
>>>
>>> # Now, create LUN 1 and another Port Symlink to a new device on the same $IQN/tpgt_1
>>> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
>>> # Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 1
>>> # to lvm_test0 and give it the port symbolic name of lio_east_port
>>> ln -s $TARGET/pscsi_0/sdd/ "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
>>>
>>> target:~# tree $CONFIGFS
>>> /sys/kernel/config/
>>> `-- target
>>>     |-- core
>>>     |   |-- fileio_0
>>>     |   |   |-- file_object
>>>     |   |   |   |-- dev_control
>>>     |   |   |   |-- dev_enable
>>>     |   |   |   `-- dev_info
>>>     |   |   `-- hba_info
>>>     |   |-- iblock_0
>>>     |   |   |-- hba_info
>>>     |   |   `-- lvm_test0
>>>     |   |       |-- dev_control
>>>     |   |       |-- dev_enable
>>>     |   |       `-- dev_info
>>>     |   |-- pscsi_0
>>>     |   |   |-- hba_info
>>>     |   |   `-- sdd
>>>     |   |       |-- dev_control
>>>     |   |       |-- dev_enable
>>>     |   |       `-- dev_info
>>>     |   |-- rd_dr_0
>>>     |   |   |-- hba_info
>>>     |   |   `-- ramdisk0
>>>     |   |       |-- dev_control
>>>     |   |       |-- dev_enable
>>>     |   |       `-- dev_info
>>>     |   `-- rd_mcp_0
>>>     |       |-- hba_info
>>>     |       `-- ramdisk0
>>>     |           |-- dev_control
>>>     |           |-- dev_enable
>>>     |           `-- dev_info
>>>     |-- iscsi
>>>     |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
>>>     |   |   `-- tpgt_1
>>>     |   |       |-- lun
>>>     |   |       |   |-- lun_0
>>>     |   |       |   |   |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
>>>     |   |       |   |   |-- port_control
>>>     |   |       |   |   `-- port_info
>>>     |   |       |   `-- lun_1
>>>     |   |       |       |-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
>>>     |   |       |       |-- port_control
>>>     |   |       |       `-- port_info
>>>     |   |       |-- np
>>>     |   |       |   `-- 172.16.201.137:3260
>>>     |   |       |       `-- portal_info
>>>     |   |       |-- tpg_control
>>>     |   |       `-- tpg_enable
>>>     |   `-- lio_version
>>>     `-- version
>>>
>>> 22 directories, 29 files
>> It's good, I like it. The only thing concerns me that, considering how 
>> much time *I* spent to understand it, for an average user understanding 
>> it can be an unbearable nightmare ;)
>>
> 
> Well, the idea is not necessarily making the configfs interface the
> easiest to use in the world by user directly through $CONFIGFS, but to
> make the CLI scripts that speak $CONFIGFS/target CLI, and of course the
> actual UIs for user that interact with generic target core and
> $FABRIC_MODs be as simple and elegent as possible.  
> 
> That is what I believe the balance that a configfs enabled generic
> target core provides to both the $CONFIGFS/target API and to $FABRIC_MOD
> maintainers looking to port their code to use a generic control
> infrastructure.  :-)
> 
>> In a few days I'll write a proposed configfs hierarchy for existing SCST 
>> /proc interface.
> 
> Sounds good!  Please let me know if you have questions.

There's one unsolved problem. As I've already written, SCST core needs 
an ability to provide to user space a large amount of data, which may 
not fit to a single page. A list of connected initiators ("sessions" 
file in /proc), for instance. Each initiator in that list has a number 
of attributes: initiator name, target template name, count of 
outstanding commands, etc. The logical way for that would be to create a 
subdirectory for each initiator, like:

/sys/kernel/config/
`-- target
     `-- sessions
         `-- session1
         |   |-- initiator_name
         |   |-- template_name
         |   `-- commands
         |
         `-- session2
             |-- initiator_name
             `-- template_name
             `-- commands

But looks like configfs requires each subdirectory to be created 
manually by user via, e.g., mkdir command. It would be really strange if 
we require user to manually create "sessions" subdirectory to be able to 
see a list of connected initiators. Do I miss anything?

Vlad
