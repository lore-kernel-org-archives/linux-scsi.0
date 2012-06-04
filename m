From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: Different WARNING:
	drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in	reference
 from the function init_module() to the function
	.exit.text:fcoe_transport_exit()
Date: Mon, 4 Jun 2012 23:11:01 +0000
Message-ID: <138EA028228D124A900F5E6746F3C216286EAA65@ORSMSX102.amr.corp.intel.com>
References: <20120602161502.GW16584@smp.if.uj.edu.pl>
 <20120604143643.GJ32472@redhat.com>
 <20120604163556.GA12303@merkur.ravnborg.org>
 <20120604190857.GB16584@smp.if.uj.edu.pl>
 <20120604191757.GA21821@merkur.ravnborg.org>
 <138EA028228D124A900F5E6746F3C216286EA866@ORSMSX102.amr.corp.intel.com>
 <20120604223341.GA28585@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab2FDXLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2012 19:11:03 -0400
In-Reply-To: <20120604223341.GA28585@merkur.ravnborg.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, "Love, Robert W" <robert.w.love@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> 
> > However, fcoe_transport_exit() is called only in module *exit* path by
> the
> > module exit func libfcoe_exit(), not in the init_module error path. Let
> me
> > take a objdump of the libfcoe.o to see where your above section
> mismatch warning
> > is from. Is this on 32bit only?
> 
> static int __init libfcoe_init(void)
> {
>         int rc = 0;
> 
>         rc = fcoe_transport_init();
>         if (rc)
>                 return rc;
> 
>         rc = fcoe_sysfs_setup();
>         if (rc)
>                 fcoe_transport_exit();    <=============
> 
>         return rc;
> }
> 
> It is called from __init context here.
> 
> 
> 
> 
> static void __exit libfcoe_exit(void)
> {
>         fcoe_sysfs_teardown();
>         fcoe_transport_exit();     <==============
> }
> 
> And from __exit context here.
> This is -rc1.
> 
> 	Sam
Ah...haven't pulled the rc1 yet, which was why I did not see the this.
Anyway, yeah you are right, dropping __exit should fix the problem.

thanks,
yi

