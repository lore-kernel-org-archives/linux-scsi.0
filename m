From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 11:39:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924183907.GA1330@beaverton.ibm.com>
References: <200209241346.g8ODkER09516@localhost.localdomain> <3D90A79F.47A37BC2@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D90A79F.47A37BC2@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Russell King <rmk@arm.linux.org.uk>, linux-scsi@vger.kernel.org

Luben Tuikov [luben@splentec.com] wrote:
> Add a flag, say unsigned I:1; to scsi_cmnd, which if set to 1, will
> make add it to the head of the queue, irrespective of its serial
> number, else the command is added according to its serial number
> in the pending commands queue.

The code path currently being discussed is a request path and we do not
have a scsi_cmnd until it is processed by the scsi_request_fn. There is
already an interface to insert the request at the head of the queue
scsi_insert_special_req, but we always set it to 0. We also do not
expose this interface high enough to let requests set this. We do
expose it through the older scsi_insert_special_cmd interface used by
scsi_mlqueue_insert.

-andmike
--
Michael Anderson
andmike@us.ibm.com

