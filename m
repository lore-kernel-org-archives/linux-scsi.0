From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 15/15] Add Documentation/DocBook/scsi_midlayer.tmpl and
 add to Makefile.
Date: Fri, 26 Oct 2007 23:05:57 -0700
Message-ID: <20071026230557.2ac5f9c8.rdunlap@xenotime.net>
References: <200710262318.01021.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:45288 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751390AbXJ0GGE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Oct 2007 02:06:04 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:05:58 -0700
In-Reply-To: <200710262318.01021.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 26 Oct 2007 23:18:00 -0500 Rob Landley wrote:

> From: Rob Landley <rob@landley.net>
> 
> Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.


I have comments for all 15 patches here.

a.  You should cc: the maintainer who you want/expect to apply the
	patches.  Always.  Andrew Morton is the only person who
	trolls for patches on a mailing list.  :)

b.  The function "Description:" section header is not strictly
	required by scripts/kernel-doc.  It will assume that the
	first text section after parameters is the Description:
	section.  FYI.

c.  Extraneous whitespace.  Git or quilt check for this.
	I don't know about hg...

patch 2:
Warning: trailing whitespace in line 60 of drivers/scsi/scsicam.c

patch 6:
Warning: trailing whitespace in line 185 of drivers/scsi/scsi_ioctl.c

patch 15:
Warning: trailing whitespace in lines 8,43 of Documentation/DocBook/scsi_midlayer.tmpl



The docbook builds cleanly and all of my following comments are just
for cleanups/fixes.


General:  SCSI, not scsi (in text descriptions, sentences, etc.)
General:  IRQ, not irq (in text)
General:  LLD, not lld (in text) (or LLDD, not lldd)


Chap. 1:
Can't SCSI commands also be 32 bytes long?

Chap. 3:  Mid-layer:

It would make more sense to me to put extra comments like
	Main file for the scsi midlayer.
just after the source file name instead of after all of the documented
interfaces in that file.


scsi_finish_command - needs a short description on the first kernel-doc line.
scsi_track_queue_full - ditto

__scsi_device_lookup_by_target:  fix text:
The only reason why drivers would want to use this is because they're need to access the device list in irq context.

s/would want to/should/
s/they're/they/

scsi_eh_finish_cmd:

thus we really

s/thus/Thus/

scsi_eh_get_sense:
proccessed (sp)

This has the unfortunate side effect that if a shost adapter does not
automatically request sense information, that we end up shutting it down
before we request it.

Ugh.  Fix.

scsi_sense_desc_find:
short function description needs to be all on one line and no blank
line before parameters.

scsi_get_sense_info_fld:
same comments as above.

scsi_init_devinfo:
Don't end kernel-doc with **/  (this is just a convention, not a
syntax rule).

HTML output of the function description is there 2 times.
I'll look into this problem.

scsi_mode_sense:
function short description must be on one line only (can be a long line
	if needed)
Description text is repeated in html output; this is usually due to
the function desc. being on multiple lines.

scsi_device_set_state:
short func desc on one line only.


scsi_internal_device_block:
short func desc on one line only.


scsi_kunmap_atomic_sg:
short func desc on one line only.

scsi_target_reap:
no blank line before parameter list

scsi_inq_str:
short func desc on one line only.


scsi_host_set_state:
short func desc on one line only.

scsi_host_lookup:
no blank line before parameter list

fc_host_post_event:
short func desc on one line only.

fc_host_post_vendor_event:
a fc_host

s/a/an/

fc_remove_host:
short func desc on one line only.

fc_remote_port_add:
short func desc on one line only.

fc_remote_port_delete:
short func desc on one line only.

fc_remote_port_rolechg:
short func desc on one line only.

iscsi_destroy_conn:
This can be called from a LLD or iscsi_transport.

s/a/an/

sas_remove_children:
sas_remove_host:
sas_phy_alloc:
sas_phy_add:
sas_phy_free:
sas_phy_delete:
scsi_is_sas_phy:
sas_port_delete:
scsi_is_sas_port:
sas_rphy_add:
sas_rphy_free:
sas_rphy_delete:
sas_rphy_remove:
scsi_is_sas_rphy:
sas_attach_transport:
sas_release_transport:
s/--/-/  in first line of kernel-doc

sas_port_add:
no blank line before parameter list


srp_rport_add:
no blank line before parameter list

srp_rport_del:
srp_remove_host:
srp_attach_transport:
srp_release_transport:
s/--/-/  in first line of kernel-doc


###
Thanks,
---
~Randy
