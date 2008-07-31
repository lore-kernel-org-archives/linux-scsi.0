From: Gal Rosen <galr@storwize.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Thu, 31 Jul 2008 09:12:23 +0300
Message-ID: <1217484743.25491.7.camel@galr-linux>
References: <488E02DE.5080100@vlnb.net>
	 <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:52065 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752570AbYGaGMi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 02:12:38 -0400
In-Reply-To: <488E0C78.80205@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Andrew,

Add checking of the flag online still does not answer the race that Vlad
stated before, unless you thought about another way without lock to
protect this thread.

> Nope, taking only one that hunk from this patch isn't sufficient.
> Around 
> dpc_thread there is pretty simple and classical race. You can't do
> 
> if (x != NULL)
> y = *x;
> 
> without any protection, if x can be set to NULL by another thread. It 
> can happen exactly between "if" and "*x" and hence lead to a crash,
> correct?

Gal.
