From: Steve Wilcox <spwilcox@att.com>
Subject: Re: 2.6 and DEC HSG80
Date: Fri, 18 Nov 2005 12:33:09 -0500
Message-ID: <1132335190.27509.5.camel@aptis101.cqtel.com>
References: <20051118112540.GB13447@michele.pupazzo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail131.messagelabs.com ([216.82.242.99]:44759 "HELO
	mail131.messagelabs.com") by vger.kernel.org with SMTP
	id S964782AbVKRRdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 12:33:13 -0500
In-Reply-To: <20051118112540.GB13447@michele.pupazzo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michele Baldessari <michele-lists@pupazzo.org>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

Actually that was my doing, and the below patch is incorrect (thus the
1/2 hour of device type 31 entries).  The correct patch has been merged
into the 2.6.14 kernel and can be seen here: http://www.kernel.org/git/?
p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=507caac75e86bd041c5462e5e988fb7138e21d79

The original thread that lead to the patch can be found here:
http://sourceforge.net/forum/forum.php?thread_id=1270421&forum_id=355154

Hope that helps - feel free to e-mail me directly if you have any
questions about the convoluted mess that led up to this.

-steve

On Fri, 2005-11-18 at 12:25 +0100, Michele Baldessari wrote:
> Hi,
> 
> While struggling to get a DEC HSG80 working with a qla2312 FC card with a 2.6 kernel, 
> I noticed that the following patch:
> 
> --- linux-2.6.13.4/drivers/scsi/scsi_devinfo.c.orig 2005-11-17 17:52:49.424914776 +0100
> +++ linux-2.6.13.4/drivers/scsi/scsi_devinfo.c  2005-11-17 17:53:12.938400491 +0100
> @@ -135,7 +135,7 @@
>         {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>         {"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>         {"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
> -       {"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
> +       {"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
>         {"DELL", "PV660F", NULL, BLIST_SPARSELUN},
>         {"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
>         {"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},     /* Dell PV 530F */
> 
> (to be found at http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-04/0511.html)
> 
> was never applied (probably because the poster didn't follow up on James' question).
> 
> Applying this patch, I am able to see the device correctly, although I get a good half an hour
> of messages like:
> 
> scsi: unknown device type 31
>   Vendor: DEC       Model: HSG80             Rev: V86F
>   Type:   Unknown                            ANSI SCSI revision: 02
> 
> on my syslog. But I guess those will be fixable by tweaking the max_report_luns option (Will do 
> on monday once I get a hold of such machine).
> 
> So, to the point, could the above patch be integrated? Any specific
> testing I should be doing to get it integrated?
> 
> thanks,
> Michele
> 
> ps. for the record kernels >= 2.6.14 end up in a soft lockup in the qla drivers 
> (see <20051116193608.GA8500@michele.pupazzo.org> for the full report)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
