From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_add_host() context
Date: Tue, 19 Nov 2002 00:02:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119000233.A3015@infradead.org>
References: <3DD841CE.3010309@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DD841CE.3010309@torque.net>; from dougg@torque.net on Mon, Nov 18, 2002 at 12:26:38PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 18, 2002 at 12:26:38PM +1100, Douglas Gilbert wrote:
> While examining the various calls in the mid level that
> can be called from a LLD, most are designed to
> be called from an interrupt or related context
> (e.g. scsi_adjust_queue_depth() ).
> 
> However, the detection of a new host requires a LLD to call 
> scsi_register() and scsi_add_host(). The latter call does
> a SCSI bus scan which takes time and sends commands like
> INQUIRY and REPORT_LUNS back through the LLD. So scsi_add_host()
> should not be called from an interrupt context. Can this be
> guaranteed in a hotplug environment? Is a worker thread
> required?

For the driver model ->probe is defined to run in process context, yes.

