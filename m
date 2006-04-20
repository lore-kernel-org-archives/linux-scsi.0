From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Wed, 19 Apr 2006 17:27:33 -0700
Message-ID: <20060419172733.d61e3365.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
	<20060413132932.31871824.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604132256490.4711@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:51928 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751243AbWDTAZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 20:25:08 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 17:25:06 -0700
In-Reply-To: <Pine.LNX.4.60.0604132256490.4711@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Thu, 13 Apr 2006 23:02:04 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Thu, 13 Apr 2006, Randy.Dunlap wrote:
> 
> > On Sun, 2 Apr 2006 21:57:43 +0200 (CEST) Guennadi Liakhovetski wrote:
> > 
> > > Hello all,
> > > 
> > > This time I really mean it:-)
> > 
> > Hi Guennadi,
> > James pointed me at this patch since I have aha152x also having
> > problems with using page_address() while trying to do PIO.
> > I see a NULL pointer during a data-out phase.  I'll attempt
> > to use the kmap_atomic() support that you have added in the
> > aha152x driver.
> 
> Would be great to put these functions under some more extensive testing! 
> I also want to use them in tmscsim, but there I do not have a test case 
> for PIO:-(

I have a patch that seems to work for the data-in phase of the
aha152x (_cs) driver.  However, the data-out phase is causing
data corruption.  (I'm only using it on a test target, so no big
deal.)

Does anyone know/recall this condition in aha152x.c::datao_end() ?
("bytes to resend"):

	if(TESTLO(DMASTAT, DFIFOEMP)) {
		int data_count = (DATA_LEN - CURRENT_SC->resid) - GETSTCNT();

		DPRINTK(debug_datao, DEBUG_LEAD "datao: %d bytes to resend (%d written, %d transferred)\n",
			CMDINFO(CURRENT_SC),
			data_count,
			DATA_LEN-CURRENT_SC->resid,
			GETSTCNT());

		CURRENT_SC->resid += data_count;

and then (if use_sg), the driver mucks with the SCp scratch/work area:

		if(CURRENT_SC->use_sg) {
			data_count -= CURRENT_SC->SCp.ptr - SG_ADDRESS(CURRENT_SC->SCp.buffer);
			while(data_count>0) {
				CURRENT_SC->SCp.buffer--;
				CURRENT_SC->SCp.buffers_residual++;
				data_count -= CURRENT_SC->SCp.buffer->length;
			}
			CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer) - data_count;
			CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length + data_count;
		} else {
			CURRENT_SC->SCp.ptr           -= data_count;
			CURRENT_SC->SCp.this_residual += data_count;
		}
	}

Does modifying the SCp: buffer, buffers_residual, ptr, this_residual...
tell the SCSI mid-layer anything?  or does this tell the driver
internally where to restart a data transfer?  (if so, where is that,
if anyone knows.  I can't find it.)

---
~Randy
