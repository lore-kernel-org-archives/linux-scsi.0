From: Bernd Schubert <bs@q-leap.de>
Subject: Re: mptsas problem
Date: Mon, 7 Apr 2008 13:36:36 +0200
Message-ID: <200804071336.36686.bs@q-leap.de>
References: <20080406195628.GA1084@animx.eu.org> <0631C836DBF79F42B5A60C8C8D4E8229F64FC1@NAMAIL2.ad.lsil.com> <20080407010738.GB1952@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:37088 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYDGLgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 07:36:38 -0400
In-Reply-To: <20080407010738.GB1952@animx.eu.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, Lars =?iso-8859-1?q?T=E4uber?= <taeuber@bbaw.de>, James Bottomley <James.Bottomley@hansenpartnership.com>

Hi all,

On Monday 07 April 2008 03:07:38 Wakko Warner wrote:
> Moore, Eric wrote:
> > The other fellow was having his controller go into fault state, that is
> > not the case here.   Here commands are not completing back from [0:0:0:0]
> > device in the timeout period, typically 30 seconds.   Its hard to tell
> > from

from my point of view the error handler is by far too quiet by default. Below 
are some patches to improve the situation. I tested these patches with 
Infortrend scsi-raid systems und LSI scsi HBAs.

With these patches the error handler will now tell why it got activated. We 
also had  the problem the error handler got activated in an endless loop, 
several of these patches are to prevent this.

http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/2.6.22-eh-patches.tar.bz2

>From the series file:

print_eh_activation.patch
scsi_error_limit.patch
scsi_error_state.patch
soft_error_requeue.patch
starget_quiesce_ignore_offlined.patch
scsi_eh_did_no_connect.patch
fusion_tip.patch

All except the fusion_tip.patch are patches for the error handler. 
fusion_tip.patch will replace the kernel mpt fusion driver by a more recent 
version I got from Eric.



Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
