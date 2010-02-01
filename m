From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
 points
Date: Mon, 01 Feb 2010 13:43:19 +0900
Message-ID: <4B665BE7.8040001@jp.fujitsu.com>
References: <4B56A621.2070301@jp.fujitsu.com> <yq1ockpky1h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ockpky1h.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:
> 
> +	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
>                               ^^^^^^^^^^
> 
> I'm not sure anybody cares about channels in this millennium so that may
> be a waste of space.
> 
> 
> +scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
> +scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
> +scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
> +scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)
> 
> Would be handy to get FUA and {RD,WR}PROTECT decoded in these commands.
> And prot_op would be nice too.
> 
> Other decode-worthy commands might be WRITE SAME(16) and UNMAP.

Thanks for the suggestions.  I'm going to post v2 series of this
patchset soon, and please note, in that version, I didn't add the
decoding on these stuff you mentioned above.

> +scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
> +{
>         [...]
> +	case READ_32:
> +	case WRITE_32:
> +		return scsi_trace_rw32(p, cdb, len);
> 
> This won't work.  READ/WRITE(32) are variable length commands.  They
> share the same operation code and are distinguished by the service
> action field.  Several of the most recent additions to the SCSI
> protocols are implemented like this.
> 
> Other commands requiring two-level parsing are READ CAPACITY(16) and GET
> LBA STATUS.

This is definitely a valid point.  In the v2 patchset, I tried to
fix it.  (Only DIF_TYPE2 READ/WRITE(32) are handled in that
version.)  It'd be great if you would review it.

I'm sorry that I didn't reply sooner.

Thanks,
Kei
