From: Luben Tuikov <luben@splentec.com>
Subject: Re: ide-scsi data transfer residuals
Date: Tue, 16 Jul 2002 14:00:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D345F55.B8A2B21D@splentec.com>
References: <000301c2242d$596450f0$e0019d89@cybernetics.com> <3D265179.BB1444E1@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Douglas Gilbert wrote:
> 
> Of the drivers that support "resid" most given a scatter
> gather list will use the sum of the element lengths instead
> of bufflen. Unfortunately that sum can be larger the bufflen
> due to padding and alignment requirements of the most backward
> DMA engines out there (I was burnt by the aha1542 ISA card).

And aic7xxx ``supports'' only that kind of ``residual'' ONLY
for SCSI READ, but is seems to use scsi_cmnd::bufflen for SCSI
WRITE.

Anyway, I consider this a bug as all data was read after a READ but by
setting scsi_cmd::resid in the low-level device driver (aic7xxx)
nothing works (fs layer)...

> IOW HBA driver writers, please use bufflen.

This message should probably be put somewhere right in
scsi_cmnd definition.

-- 
Luben
