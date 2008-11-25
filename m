From: Sven Schuetz <sven@linux.vnet.ibm.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Tue, 25 Nov 2008 16:08:13 +0100
Message-ID: <492C14DD.9050800@linux.vnet.ibm.com>
References: <1227043498.4949.21.camel@ogier> <492ACC5F.8070004@linux.vnet.ibm.com> <492AD651.7020307@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41059 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYKYPIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 10:08:15 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id mAPF8Ekt004063
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2008 15:08:14 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAPF8EGe2580486
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2008 15:08:14 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAPF8EoW014798
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2008 15:08:14 GMT
In-Reply-To: <492AD651.7020307@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "seokmann.ju@qlogic.com" <seokmann.ju@qlogic.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>

James Smart wrote:
> Sven Schuetz wrote:
>> Shouldn't we add FC_BSG_HST_CT_NOLOGIN as well?
> 
> I didn't add this as FC-GS-6 r9.21, which defines the CT protocol, says:
>  4.5.2.1 Fabric login and N_Port login
>   An Nx_Port shall perform Fabric Login, and shall perform N_Port Login
>   with the WKA or N_Port Identifier where the Service is offered, in the
>   manner that is specified in FC-FS, before making any requests
>   of a Server provided by the Service. An Nx_Port that has completed its
>   registration with a Server shall perform explicit N_Port Logout with
>   the Service. An Nx_Port that has completed any other requests with a
>   Server should also perform explicit N_Port Logout with the Service.
> 
> So - a login for CT requests is a must (at least as I read it).
> 
> That's not the case for ELS's, which can usually survive on an implicit
> login - especially things like ADISC/PDISC.   Login is also the
> distinction in my opinion for whether something should or should not be
> exported via an rport in the transport.

Hi James,

I agree.

>> As far as I can see from looking over the patch (correct me when I am
>> wrong),
>> the way to issue a CT request now is to send an FC_BSG_HST_ADD_RPORT
>> for the wka
>> port in question (if not enumerated by the driver, which zfcp does not
>> do), then
>> send the FC_BSG_RPT_CT followed by a FC_BSG_HST_DEL_RPORT. I was under
>> the
>> impression the CT stuff was one of the main reasons to have devices
>> for the
>> fc_host. What do you think?
> 
> Your flow is exactly what I intended...

OK, let me be a bit more precise. Maybe I shouldn't have called it
FC_BSG_HST_CT_NOLOGIN but something like FC_BSG_HST_CT_NOT_ENUMERATE.

As the FS-GS dictates, we do a port login and logout for CT requests, but
completely in the driver. We do that for some internal CT stuff and I have
implemented it for userspace CT requests with Seokmanns patch as well. We just
do not advertise the ports to fc_transport (we are only logged in for the
duration of the request). Having to react to FC_BSG_HST_ADD_RPORT would mean to
rewrite our wka port handling, plus some of it is done in our firmware and not
in zfcp.

So my suggestion would be to add something like FC_BSG_HST_CT_NOT_ENUMERATE for
drivers that do the port logins on their own. Other drivers can respond with an
error code, making it necessary for the app to do the port login on their own
(FC_BSG_HST_ADD_RPORT), that means following the procedure I outlined in my
previous mail.

In addition, userspace apps that deal with complete CT frames (like
implementations of HBA API) would not have to rip the frame apapart to find out
the generic service/wka port in question and then do the port login. They can
just send the frame to the driver and rely on the driver to do the port
login/logout.

Sven
