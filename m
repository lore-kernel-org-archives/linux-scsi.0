From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 07/12] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Mon, 21 Mar 2011 18:50:51 -0700
Message-ID: <1300758651.21880.207.camel@haakon2.linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
	 <1300613497-2091-8-git-send-email-nab@linux-iscsi.org>
	 <4D87F5E6.3010208@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D87F5E6.3010208@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-21 at 20:05 -0500, Mike Christie wrote:
> On 03/20/2011 04:31 AM, Nicholas A. Bellinger wrote:
> > +static struct iscsi_chap *chap_server_open(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_node_auth *auth,
> > +	const char *A_str,
> > +	char *AIC_str,
> > +	unsigned int *AIC_len)
> 
> Lot of mixed cases like this and below in the patch.
>
> > +static int chap_server_compute_md5(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_node_auth *auth,
> > +	char *NR_in_ptr,
> > +	char *NR_out_ptr,
> > +	unsigned int *NR_out_len)
> 
> 

<nod>, fixing this up in lio-4.1 now..

> 
> > +	return 2;
> > +}
> > diff --git a/drivers/target/iscsi/iscsi_target_auth.h b/drivers/target/iscsi/iscsi_target_auth.h
> > new file mode 100644
> > index 0000000..17b042d
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_auth.h
> 
> 
> 
> > +
> > +struct iscsi_chap {
> > +	unsigned char	digest_type;
> > +	unsigned char	id;
> > +	unsigned char	challenge[CHAP_CHALLENGE_LENGTH];
> > +	unsigned int	challenge_len;
> > +	unsigned int	authenticate_target;
> > +	unsigned int	chap_state;
> > +} ____cacheline_aligned;
> > +
> 
> Why are almost all structs in the patches ____cacheline_aligned? Is it 
> something we are just doing now, or does this affect performance somehow 
> even though the struct is not used in a perf path?

For this particular case I wanted to make sure it was at least 32-bit
word aligned for ARM to avoid the unaligned penalites for the single
byte unsigned chars.

There is also a handful of single byte unsigned chars, u8, and u16
structure membmer usage in iscsi_target_core.h that is using
____cacheline_aligned using in the non performance critical path.
I would be happy to do a audit on these and convert to using the packed
attributed..

Just to double check, what is mainline convention for handling
structures like this for 32-bit word aligned ISAs..?

Thanks for your review Mike!

--nab
