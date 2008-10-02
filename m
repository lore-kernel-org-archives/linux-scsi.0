From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: ConfigFS enabled Generic Target Mode
	andiSCSI Target	Stack on v2.6.27-rc7
Date: Thu, 02 Oct 2008 14:47:46 -0700
Message-ID: <1222984066.15764.131.camel@haakon2.linux-iscsi.org>
References: <C2F174F99918D54CA2A96E57C5079B6F9FAC9C@sbc-exmsg2.sbcounty.gov>
	 <48E4FE98.7050409@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:22585 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754482AbYJBVrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 17:47:49 -0400
In-Reply-To: <48E4FE98.7050409@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Sufficool, Stanley" <ssufficool@rov.sbcounty.gov>, scst-devel@lists.sourceforge.net, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-10-02 at 21:02 +0400, Vladislav Bolkhovitin wrote:
> Sufficool, Stanley wrote:
> > 
> >> -----Original Message-----
> >> From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org] 
> >> Sent: Monday, September 29, 2008 12:22 PM
> >> To: LKML; linux-scsi; Linux-iSCSI.org Target Dev; SCST-Devel; iet-dev
> >> Cc: FUJITA Tomonori; Mike Christie; Vladislav Bolkhovitin; 
> >> Greg KH; Joel Becker; Jerome Martin; James Bottomley; H. Peter Anvin
> >> Subject: [Scst-devel] [ANNOUNCE]: ConfigFS enabled Generic 
> >> Target Mode andiSCSI Target Stack on v2.6.27-rc7
> >>
> >>

<SNIP>

> >>
> >> target:~# tree $CONFIGFS
> >> /sys/kernel/config/
> >> `-- target
> >>     |-- core
> >>     |   |-- fileio_0
> >>     |   |   |-- file_object
> >>     |   |   |   |-- dev_control
> >>     |   |   |   |-- dev_enable
> >>     |   |   |   `-- dev_info
> >>     |   |   `-- hba_info
> >>     |   |-- iblock_0
> >>     |   |   |-- hba_info
> >>     |   |   `-- lvm_test0
> >>     |   |       |-- dev_control
> >>     |   |       |-- dev_enable
> >>     |   |       `-- dev_info
> >>     |   |-- pscsi_0
> >>     |   |   |-- hba_info
> >>     |   |   `-- sdd
> >>     |   |       |-- dev_control
> >>     |   |       |-- dev_enable
> >>     |   |       `-- dev_info
> >>     |   |-- rd_dr_0
> >>     |   |   |-- hba_info
> >>     |   |   `-- ramdisk0
> >>     |   |       |-- dev_control
> >>     |   |       |-- dev_enable
> >>     |   |       `-- dev_info
> >>     |   `-- rd_mcp_0
> >>     |       |-- hba_info
> >>     |       `-- ramdisk0
> >>     |           |-- dev_control
> >>     |           |-- dev_enable
> >>     |           `-- dev_info
> >>     |-- iscsi
> >>     |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
> >>     |   |   `-- tpgt_1
> >>     |   |       |-- lun
> >>     |   |       |   |-- lun_0
> >>     |   |       |   |   |-- lio_west_port -> 
> >> ../../../../../../target/core/iblock_0/lvm_test0
> >>     |   |       |   |   |-- port_control
> >>     |   |       |   |   `-- port_info
> >>     |   |       |   `-- lun_1
> >>     |   |       |       |-- lio_east_port -> 
> >> ../../../../../../target/core/pscsi_0/sdd
> >>     |   |       |       |-- port_control
> >>     |   |       |       `-- port_info
> >>     |   |       |-- np
> >>     |   |       |   `-- 172.16.201.137:3260
> >>     |   |       |       `-- portal_info
> >>     |   |       |-- tpg_control
> >>     |   |       `-- tpg_enable
> >>     |   `-- lio_version
> >>     `-- version
> >>
> >> 22 directories, 29 files
> >>
> >> --nab
> > 
> > My 2 cents as a user of the current SCST infrastructure and with no clue
> > how ConfigFS works:
> > 
> > If ConfigFS is able to isolate the settings and "switches" to individual
> > directories, do we really need the prefixes on the switches? 
> > 
> > dev_control/dev_enable/dev_info = control/enable/info since we know we
> > are in a device config directory. Same for port, hba, etc?
> > 
> > This would IMHO enable simpler development of an all in one user tool
> > for managing all these switches and configs.
> 
> Yes, I think, you're right. Additionally, no existing entries in sysfs 
> has prefixes like that. So, it would be better to remove them.
> 

Sounds good. Here is the commit:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=374e8ace84ca58490be22d881f017d48c6742b50

Thanks for your comments!

--nab

