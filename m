From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Wed, 24 Sep 2003 12:09:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F71C1CA.5030004@pobox.com>
References: <20030924151228.8206.qmail@web60208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30138 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261459AbTIXQKA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:10:00 -0400
In-Reply-To: <20030924151228.8206.qmail@web60208.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jpd_hp_linux_scsi@yahoo.com

jd wrote:
> Hi,
> 
> Available for first Review & Comments.
> 
> The UNH iSCSI Project, a collaborative effort between the
> UNH IOL and Hewlett Packard Company in Austin, Texas,
> ( hosted at http://sourceforge.net/projects/unh-iscsi )
> to produce a full feature, generic iSCSI implementation ,
> has ported the 2.4.18/20 version of the iSCSI initiator to
> Linux 2.6.test5 Kernel for consideration of inclusion for
> future distribution.
> 
> A patch file is available for review at:
> 
> http://www.parisc-linux.org/~jpd/
> 
> Files included in the patch :
> 
>  drivers/scsi/Makefile
>  drivers/scsi/Kconfig
>  drivers/scsi/unh_iscsi
>  drivers/scsi/unh_iscsi/initiator     # HBA & Data mover
>  drivers/scsi/unh_iscsi/common        # Login and shared files
>  drivers/scsi/unh_iscsi/security       $ SRP and CHAP login
> 
> Please submit comments to :
> 
> linux-scsi@vger.kernel.org

Please don't mangle or otherwise use non-RFC email addresses.  When you 
use your normal email address somewhere in the email _anyway_, you're 
annoying valid users while doing nothing to defeat spammers.


comments:

* use generic facility for crc32

* most of the formatting looks good, but some of it looks crazy, like

> +	add_length = scan_table_and_process(sock,
> +										p_param_tbl,
> +										SECURITY_PARAM | INFORMATIONAL_PARAM,
> +										INITIATOR,
> +										inputpdu,
> +										outputpdu,
> +										connection_flags, login_flags);

* indeed, this needs to be legible to people w/ 80-column screens

* I disagree with the need for "my_kmalloc" and "my_kfree".  Ditch the 
allocator and directly use the kernel counterparts.

* function prototypes should use "u32" not "__u32" forms.  Ditto for 
other kernel-internal structures.

* string_llx is not needed.  use sprintf.

* verbosely dumping scsi ops is something that should be more generic 
(or removed)

* authentication should be offloaded to a daemon, as NFSv4 did

* I got tired of scrolling right to read code, at this point

