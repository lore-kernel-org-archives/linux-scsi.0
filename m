From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
Date: Thu, 22 Feb 2007 11:43:48 -0800
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32BAE600E@AVEXCH2.qlogic.org>
References: <20070219181832.GA18043@us.ibm.com> <A6970E9A290F3F4682E1EAD0EA14F32BAE5E07@AVEXCH2.qlogic.org> <20070222025349.GA13701@us.ibm.com> <A6970E9A290F3F4682E1EAD0EA14F32BAE5EFC@AVEXCH2.qlogic.org> <20070222190832.GA30677@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:32756 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbXBVTnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 14:43:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20070222190832.GA30677@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org, Linux Driver <Linux-Driver@qlogic.com>

On Thursday, February 22, 2007 11:09 AM, Malahal Naineni wrote:
> I removed the cable and didn't put it back at all for more 
> than 1 hour.
> There is no recovery here.  When I disable an F-port, after 
> few seconds the remote port state is set to something other 
> than 'online'. Why not same behaviour for remote ports on 
> FL-port. With my patch, the behaviour is same whether the 
> remote port is attached to an FL-port or an F-port.
I'm sorry, I mis-understood your initial comment. The problem is
happening only with FL-port (on big-endian platform).
Let me verify it with test team in here and will get back to you.

> Well, my patch fixed the problem! qla2x00_device_resync() 
> fails to call
> qla2x00_mark_device_lost() for RSCN's affecting area or 
> domain because the following evaluates to true always due to 
> b24 field being incorrect:
> 
> 		(fcport->d_id.b24 & mask) != d_id.b24
Agree, your patch will fix it. However, my point is that: instead of
having #idfef in the header, 
1. make access to the structure member to be equal in size. 
2. or introduce macro that combins al_pa/area/domain
Those are preferred solution, in my opinion. 

Again, thank you for your findings. 
Based on your findings, let us investigate further and come up with
right answer for it.

Thank you,

Seokmann
