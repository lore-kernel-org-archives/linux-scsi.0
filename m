From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Problem with 2.6 kernel and sym53c8xx driver
Date: Wed, 1 Mar 2006 12:04:46 -0700
Message-ID: <20060301190446.GD1598@parisc-linux.org>
References: <440481D2.6030107@iutc3.unicaen.fr> <20060301132055.GA1598@parisc-linux.org> <4405EF0E.1090403@iutc3.unicaen.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:27084 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932122AbWCATEs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 14:04:48 -0500
Content-Disposition: inline
In-Reply-To: <4405EF0E.1090403@iutc3.unicaen.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrien Corbi?re <corbiere@iutc3.unicaen.fr>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 01, 2006 at 07:59:26PM +0100, Adrien Corbi?re wrote:
> Matthew Wilcox a ?crit :
> 
> >This looks like a problem with the BROWNIE device, as I've found a
> >similar problem here:
> >http://lists.suse.com/archive/suse-amd64/2004-Mar/0069.html

> Thanks a lot! I've applyed the patch on kernel 2.6.15.4, and it works 
> very well ! The ouput of dmesg is :

My goodness.  Looks like when it gets a REPORT_LUNs, it just spews
complete crap onto the scsi bus ;-)

James, can we add this one to the blacklist?

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/scsi_devinfo.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_devinfo.c,v
retrieving revision 1.16
diff -u -p -r1.16 scsi_devinfo.c
--- ./drivers/scsi/scsi_devinfo.c	17 Jan 2006 14:51:49 -0000	1.16
+++ ./drivers/scsi/scsi_devinfo.c	1 Mar 2006 13:17:21 -0000
@@ -126,6 +126,7 @@ static struct {
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
