From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Tue, 4 Oct 2011 16:38:21 -0700
Message-ID: <CAA9_cmeXEHgpEsZOoUYfQyrAcS2hQr8Qqm2Zai=KPXnoVaVUAA@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
	<A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn>
	<CAA9_cmdq455AZJUPNdjCrn7JT90AXZtZbGGejcpLDX3zYfu+2A@mail.gmail.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE711@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com>
	<CAA9_cmdAx7pw-2scX=mYP=i4zpAH+fAF-0WNM4cg97Ng6xFNAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55888 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1JDXiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2011 19:38:22 -0400
Received: by qadb15 with SMTP id b15so824918qad.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2011 16:38:21 -0700 (PDT)
In-Reply-To: <CAA9_cmdAx7pw-2scX=mYP=i4zpAH+fAF-0WNM4cg97Ng6xFNAw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>

On Tue, Oct 4, 2011 at 4:30 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> That initially looked convincing... but on closer look
> sas_port_delete_phy is reducing the number of phys in the transport
> class representation of the port (struct sas_port), while the
> decrement that sas_deform port is doing is operating the on the
> host-local port (struct asd_sas_port).

This confusion happens so often for me as well.  Maybe it is time to
rename these structures and local variable instances, something like:

asd_sas_port --> host_sas_port
asd_sas_phy --> host_sas_phy

...and:

port --> hport
phy --> hphy

...for the local variable instances.

??
