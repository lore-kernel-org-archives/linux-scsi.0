From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: sd: block: Handle cases where devices come online
 read-only
Date: Tue, 12 Feb 2019 00:03:19 -0800
Message-ID: <20190212080319.GA10547@infradead.org>
References: <20190208233831.31377-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190208233831.31377-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 08, 2019 at 06:38:31PM -0500, Martin K. Petersen wrote:
> Some devices come online in write protected state and switch to
> read-write once they are ready to process I/O requests.

That is really weird.  What kind of devices are these?

> Note that per-partition ro settings are lost on revalidate. This has
> been broken for at least a decade and it will require major surgery to
> fix. To my knowledge nobody has complained about being unable to make
> partition read-only settings stick through a revalidate. So hopefully
> this patch will suffice as a simple fix for stable.

Should we warn when we lost these settings on a revalidate?

I have to say I don't like the tristate too much - it seems to allow
setting a hardware write protected device writable again by user
interfaction, right?

Should we just have a hardware and a user policy field that are separate
instead?
