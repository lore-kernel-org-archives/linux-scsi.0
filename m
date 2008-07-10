From: James.Smart@Emulex.Com
Subject: RE: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 12:10:22 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56316 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYGJQK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 12:10:28 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com, linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com, James.Smart@Emulex.Com

Seokmann,

Yes - the idea was that when SGIO v4 and BIDI support was finally in the
kernel
(and stable), we would utilize that interface for ELS and CT pass thru.
We will
be abusing the "scsi-ness" of this infrastructure, but should be ok.  We
can use
the "CDB" area to pass request control information, and the "Sense
Data/Response"
area to pass response control information, and the BIDI payloads for the
actual
write and read buffers.

We have a few hurdles to cross to get there though:
- We're going to create an sgio object - is the object 1:1 with
sysfs/device objects ?
  or do we allow the adapter/port to be the base object and we then pass
addressing
  information in the request control area.  I lean toward the latter, as
there may
  be things on the fabric the adapter/port does not want or does not
know about, to
  present to the OS. However, I know James is in the other camp - always
have a node
  so that the addressing is implicit in the node being talked to. But,
in order to
  do this for things that may not already be enumerated, we have to
build in a 
  funky "temporarily create object X" interface so you can then talk to
it, then
  tear it down.

- We have to figure out a way to address asynchronous reception. It's
easy to do
  the request side via BIDI, but how about an ELS/CT request to the port
? where
  do we get the buffers ? is it DMA-based ? is there multiple buffer
pools and
  a traffic classification policy ? how do we associate traffic to the
right 
  user entity ? and so on.

- Will the ideas of "abusing" the SGIO SCSI request work for generic FC
traffic.
  I believe we've got the primitives right when we could actually
support FCP
  traffic through this raw interface.

- This will all need to be clean integrated into the transport, and we
have
  to consider the open-FCOE stack as well. 

-- james s


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Seokmann Ju
> Sent: Thursday, July 10, 2008 8:56 AM
> To: linux-scsi@vger.kernel.org
> Cc: Andrew Vasquez
> Subject: bidi support: FC transport layer...
> 
> Hi,
> 
> With starting to implement FC-CT/ELS support on the qla2xxx 
> module, I  
> would like to get some idea about the bidi-bidirectional.
> As I understand that the bidi is packet transporting 
> infra-structure,  
> I think it could be good candidate for the FC specific FC-CT/ELS  
> packet delivery in between the application and the individual 
> devices  
> given topology.
> 
> As I have limited understanding about the bid, here are my questions,
> 0. would the bidi be a right choice for the FC-CT/ELS packet delivery?
> 1. where should I get any kind of documents/briefs about the bidi?
> 2. which part of code that I have to walk-through for further  
> understanding about the bidi mechanism?
> 3. with the bidi, what's the application interface should look like?
> 
> I expect to have some changes/additions in the FC transport layer in  
> regards to the support and in general.
> 
> Any comment/guidance would be greatly helpful.
> 
> Thank you,
> Seokmann
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
