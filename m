From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Different WARNING:
	drivers/scsi/fcoe/libfcoe.o(.init.text+0x1a): Section mismatch in
	reference from the function init_module() to the function
	.exit.text:fcoe_transport_exit()
Date: Tue, 5 Jun 2012 00:33:41 +0200
Message-ID: <20120604223341.GA28585@merkur.ravnborg.org>
References: <20120602161502.GW16584@smp.if.uj.edu.pl> <20120604143643.GJ32472@redhat.com> <20120604163556.GA12303@merkur.ravnborg.org> <20120604190857.GB16584@smp.if.uj.edu.pl> <20120604191757.GA21821@merkur.ravnborg.org> <138EA028228D124A900F5E6746F3C216286EA866@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.snhosting.dk ([87.238.248.203]:29617 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2FDWdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2012 18:33:43 -0400
Content-Disposition: inline
In-Reply-To: <138EA028228D124A900F5E6746F3C216286EA866@ORSMSX102.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, "Love, Robert W" <robert.w.love@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> However, fcoe_transport_exit() is called only in module *exit* path by the
> module exit func libfcoe_exit(), not in the init_module error path. Let me 
> take a objdump of the libfcoe.o to see where your above section mismatch warning
> is from. Is this on 32bit only?

static int __init libfcoe_init(void)
{
        int rc = 0;

        rc = fcoe_transport_init();
        if (rc)
                return rc;

        rc = fcoe_sysfs_setup();
        if (rc)
                fcoe_transport_exit();    <=============

        return rc;
}

It is called from __init context here.




static void __exit libfcoe_exit(void)
{
        fcoe_sysfs_teardown();
        fcoe_transport_exit();     <==============
}

And from __exit context here.
This is -rc1.

	Sam
