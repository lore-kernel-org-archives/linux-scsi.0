From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Wed, 15 Sep 2004 15:30:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4147D370.3040003@torque.net>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>	<20040904140102.A15247@infradead.org>	<Pine.LNX.4.60.0409050022570.3092@poirot.grange>	<20040904233835.A18659@infradead.org>	<Pine.LNX.4.60.0409051654460.3039@poirot.grange>	<1094398979.10977.9.camel@mulgrave>  <20040905173134.A31521@infradead.org> <1094422949.10977.15.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:9956 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267625AbUIOFbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 01:31:16 -0400
In-Reply-To: <1094422949.10977.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2004-09-05 at 12:31, Christoph Hellwig wrote:
> 
>>Umm yes.  But lets get the driver no oops first and then move forward.
>>There's still a lot of work to do on the driver.
> 
> 
> Well, OK.  I agree to putting a palliative fix in, since what I
> suggested will probably take more thought, but I don't think this one is
> actually it.  Mixing tagged and untagged commands is illegal under the
> SCSI spec.  Simply untagging the INQUIRY command may work to fix this
> particular bug, but I bet it will introduce others when a scsi utility
> sends an INQUIRY down to an in-use device.

Seems as though INQUIRY, REPORT LUNS and READ CAPACITY are special
in this respect since the task manager may (i.e. should) treat them
as implicit Head Of Queue. This proposal:
http://www.t10.org/ftp/t10/document.04/04-310r1.pdf
advises application clients not to send the "specials" with
ORDERED (i.e. tagged) task attribute.

My guess is that if any data that those "specials" monitor is changed
they will hit the next command status with an advisory
sense_key/asc/ascq sense. Then the application client should
send one of those "specials" out asap to find out what changed (and
not be held up by task manager).

Doug Gilbert
