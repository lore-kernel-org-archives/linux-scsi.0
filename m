From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] scsi: Check sense buffer size at build time
Date: Thu, 24 May 2018 07:11:44 -0700
Message-ID: <20180524141144.GA19629@infradead.org>
References: <20180522181512.39316-1-keescook@chromium.org>
 <20180522181512.39316-7-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522181512.39316-7-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +/* Make sure any sense buffer is the correct size. */
> +#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
> +		     sshdr, timeout, retries, flags, rq_flags, resid)	\
> +({									\
> +	BUILD_BUG_ON((sense) != NULL &&					\
> +		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
> +	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
> +		       sense, sshdr, timeout, retries, flags, rq_flags,	\
> +		       resid);						\
> +})

This macro gets evaluated in the scsi_execute_req inline function just
below.  So either we need to include scsi_sense.h/scsi_common.h in
scsi_device.h, or just move scsi_execute_req out of line.  The latter
sounds better to me a it's not really used in a fast path.
