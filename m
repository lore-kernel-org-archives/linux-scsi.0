From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Tue, 25 Nov 2008 10:56:41 -0500
Message-ID: <492C2039.4040407@emulex.com>
References: <1227043498.4949.21.camel@ogier> <492ACC5F.8070004@linux.vnet.ibm.com> <492AD651.7020307@emulex.com> <492C14DD.9050800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43238 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYKYPzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 10:55:44 -0500
In-Reply-To: <492C14DD.9050800@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Schuetz <sven@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "seokmann.ju@qlogic.com" <seokmann.ju@qlogic.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>

You are making many of the same arguments I tried to enumerate with 
James B when we first started discussing whether we had to enumerate 
everything before talking to it. Your points are a bit more eloquent 
than mine.  I put the ELS_NOLOGIN on the host in to test the argument.

I'm not married to requiring everything to be enumerated to talk to it 
via CT/ELS and figured in many cases, simply making the request to the 
host really was the right thing to do.  Being able to do so via the 
host, as well as via anything enumerated, plus the request to enumerate 
something, are enough primitives to cover everything.

So, following your proposal, let's add a FC_BSG_HST_CT request, that 
looks similar in form to the FC_BSG_HST_ELS_NOLOGIN request and with 
response semantics similar to the rport version.  We'll let the LLDD 
determine whether it needs to do logins/logouts, and whether it wants to 
enumerate anything in the process.

-- james s

Sven Schuetz wrote:
> OK, let me be a bit more precise. Maybe I shouldn't have called it
> FC_BSG_HST_CT_NOLOGIN but something like FC_BSG_HST_CT_NOT_ENUMERATE.
> 
> As the FS-GS dictates, we do a port login and logout for CT requests, but
> completely in the driver. We do that for some internal CT stuff and I have
> implemented it for userspace CT requests with Seokmanns patch as well. We just
> do not advertise the ports to fc_transport (we are only logged in for the
> duration of the request). Having to react to FC_BSG_HST_ADD_RPORT would mean to
> rewrite our wka port handling, plus some of it is done in our firmware and not
> in zfcp.
> 
> So my suggestion would be to add something like FC_BSG_HST_CT_NOT_ENUMERATE for
> drivers that do the port logins on their own. Other drivers can respond with an
> error code, making it necessary for the app to do the port login on their own
> (FC_BSG_HST_ADD_RPORT), that means following the procedure I outlined in my
> previous mail.
> 
> In addition, userspace apps that deal with complete CT frames (like
> implementations of HBA API) would not have to rip the frame apapart to find out
> the generic service/wka port in question and then do the port login. They can
> just send the frame to the driver and rely on the driver to do the port
> login/logout.
> 
> Sven
> 
