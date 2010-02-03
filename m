From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH 2/2 v2] scsi: add scsi trace core function and put trace
 points
Date: Wed, 03 Feb 2010 14:55:25 +0900
Message-ID: <4B690FCD.2040405@jp.fujitsu.com>
References: <4B665EC9.6000608@jp.fujitsu.com>	<4B666181.7080200@jp.fujitsu.com> <yq1636fqlkv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1636fqlkv.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:
> 
> I'm traveling so I won't have time to look at this closely until next
> week.  However, this caught my eye:
> 
> +static const char *
> +scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
> +{
> +	switch (SERVICE_ACTION(cdb)) {
> +	case READ_32:
> +	case WRITE_32:
> +		/* if protection is enabled */
> +		if (((cdb[10] >> 5) & 0x7) == 1)
> +			return scsi_trace_rw32(p, cdb, len);
> +		/* fall through */
> +	default:
> +		return scsi_trace_misc(p, cdb, len);
> +	}
> +}
> 
> It is not a requirement that a 32-byte READ/WRITE request must have
> PROTECT set.  So that if statement is bogus.

Yes.  I agree that the if statement is not necessary here.  I'll
fix it.  Thanks for having your time for the review.

Kei
