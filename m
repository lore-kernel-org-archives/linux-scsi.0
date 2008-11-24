From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Mon, 24 Nov 2008 11:29:05 -0500
Message-ID: <492AD651.7020307@emulex.com>
References: <1227043498.4949.21.camel@ogier> <492ACC5F.8070004@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59370 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYKXQ2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 11:28:11 -0500
In-Reply-To: <492ACC5F.8070004@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Schuetz <sven@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "seokmann.ju@qlogic.com" <seokmann.ju@qlogic.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>

Sven Schuetz wrote:
> Shouldn't we add FC_BSG_HST_CT_NOLOGIN as well?

I didn't add this as FC-GS-6 r9.21, which defines the CT protocol, says:
  4.5.2.1 Fabric login and N_Port login
   An Nx_Port shall perform Fabric Login, and shall perform N_Port Login
   with the WKA or N_Port Identifier where the Service is offered, in the
   manner that is specified in FC-FS, before making any requests
   of a Server provided by the Service. An Nx_Port that has completed its
   registration with a Server shall perform explicit N_Port Logout with
   the Service. An Nx_Port that has completed any other requests with a
   Server should also perform explicit N_Port Logout with the Service.

So - a login for CT requests is a must (at least as I read it).

That's not the case for ELS's, which can usually survive on an implicit 
login - especially things like ADISC/PDISC.   Login is also the
distinction in my opinion for whether something should or should not be
exported via an rport in the transport.

> As far as I can see from looking over the patch (correct me when I am wrong),
> the way to issue a CT request now is to send an FC_BSG_HST_ADD_RPORT for the wka
> port in question (if not enumerated by the driver, which zfcp does not do), then
> send the FC_BSG_RPT_CT followed by a FC_BSG_HST_DEL_RPORT. I was under the
> impression the CT stuff was one of the main reasons to have devices for the
> fc_host. What do you think?

Your flow is exactly what I intended...

I also did not involve all the rport build-up, etc in the transport for
the adding of the rport.  Just as today, all of this occurs within the
LLDD for normal discovery (deciding when to send the ELS's, when to make
the transport calls, etc) - I'm assuming the same holds true for the
add rport.

Also not addressed - how do we enable CT-receive and ELS-recieve. This,
due to the buffering and routing definitions (what process gets what)
is a fun problem.

Thanks Sven.

-- james s

