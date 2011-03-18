From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v3 07/12] iscsi-target: Add CHAP Authentication support
	using libcrypto
Date: Thu, 17 Mar 2011 17:09:49 -0700
Message-ID: <1300406989.28255.617.camel@haakon2.linux-iscsi.org>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
	 <1300398797-24536-8-git-send-email-nab@linux-iscsi.org>
	 <alpine.LNX.2.00.1103172331160.1980@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50389 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1CRAQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 20:16:53 -0400
In-Reply-To: <alpine.LNX.2.00.1103172331160.1980@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

On Thu, 2011-03-17 at 23:46 +0100, Jesper Juhl wrote:
> On Thu, 17 Mar 2011, Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> 
> Minor nitpicks below.
> 
> 
> > This patch adds support for libcrypto md5 based iSCSI CHAP authentication
> > support for iscsi_target_mod.  This includes support for mutual and one-way
> > NodeACL authentication for SessionType=Normal and SessionType=Discovery
> > via /sys/kernel/config/target/iscsi.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_target_auth.c |  500 ++++++++++++++++++++++++++++++
> >  drivers/target/iscsi/iscsi_target_auth.h |   33 ++
> >  2 files changed, 533 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/iscsi_target_auth.c
> >  create mode 100644 drivers/target/iscsi/iscsi_target_auth.h
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
> > new file mode 100644
> > index 0000000..d3711f4
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_auth.c
> > @@ -0,0 +1,500 @@
> > +/*******************************************************************************
> > + * This file houses the main functions for the iSCSI CHAP support
> > + *
> > + * ?? Copyright 2007-2011 RisingTide Systems LLC.
> 
> "??" ?
> 
> 
> > +int chap_string_to_hex(unsigned char *dst, unsigned char *src, int len)
> > +{
> > +	int i = 0, j = 0;
> > +
> > +	for (i = 0; i < len; i += 2)
> 
> Initializing 'i' to zero twice is a little needless.
> 
> 

Fixed

> > +void chap_binaryhex_to_asciihex(char *dst, char *src, int src_len)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < src_len; i++)
> 
> Do we still support compiler versions that don't understand 'for-scope'?
> 
> for (int i = 0; ...
> 
> 

Mmmm, not sure.  Adding far (...) {} usage here to be safe

> > +void chap_set_random(char *data, int length)
> > +{
> > +	long r;
> > +	unsigned n;
> > +
> > +	while (length > 0) {
> > +
> 
> Pointless newline IMHO.
> 

Removed

> > +		get_random_bytes(&r, sizeof(long));
> > +		r = r ^ (r >> 8);
> > +		r = r ^ (r >> 4);
> > +		n = r & 0x7;
> > +
> > +		get_random_bytes(&r, sizeof(long));
> > +		r = r ^ (r >> 8);
> > +		r = r ^ (r >> 5);
> > +		n = (n << 3) | (r & 0x7);
> > +
> > +		get_random_bytes(&r, sizeof(long));
> > +		r = r ^ (r >> 8);
> > +		r = r ^ (r >> 5);
> > +		n = (n << 2) | (r & 0x3);
> > +
> > +		*data++ = n;
> > +		 length--;
> 
> Mixing space and tab in indentation here.
> 
> 

Fixing up now..

> > +int chap_gen_challenge(
> > +	struct iscsi_conn *conn,
> > +	int caller,
> > +	char *C_str,
> > +	unsigned int *C_len)
> > +{
> > +	unsigned char challenge_asciihex[CHAP_CHALLENGE_LENGTH * 2 + 1];
> > +	struct iscsi_chap *chap = (struct iscsi_chap *) conn->auth_protocol;
> > +
> > +	memset(challenge_asciihex, 0, CHAP_CHALLENGE_LENGTH * 2 + 1);
> > +
> > +	chap_set_random(chap->challenge, CHAP_CHALLENGE_LENGTH);
> > +	chap_binaryhex_to_asciihex(challenge_asciihex, chap->challenge,
> > +					CHAP_CHALLENGE_LENGTH);
> > +	/*
> > +	 * Set CHAP_C, and copy the generated challenge into C_str.
> > +	 */
> > +	*C_len += sprintf(C_str + *C_len, "CHAP_C=0x%s", challenge_asciihex);
> > +	*C_len += 1;
> > +
> > +	PRINT("[%s] Sending CHAP_C=0x%s\n\n", (caller) ? "server" : "client",
> > +			challenge_asciihex);
> > +	return 0;
> 
> You only ever return '0', so why couldn't this function just return 
> 'void'?  - sorry, didn't bother to actually check how its used :-/
> 
> 

Making this function return void and declaring static as well..

> > +int chap_server_compute_md5(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_node_auth *auth,
> > +	char *NR_in_ptr,
> > +	char *NR_out_ptr,
> > +	unsigned int *NR_out_len)
> > +{
> > +	char *endptr;
> > +	unsigned char id, digest[MD5_SIGNATURE_SIZE];
> > +	unsigned char type, response[MD5_SIGNATURE_SIZE * 2 + 2];
> > +	unsigned char identifier[10], *challenge, *challenge_binhex;
> 
> If you changed the above line to 
> 
> 	unsigned char identifier[10], *challenge;
> 	unsigned char *challenge_binhex = 0;
> 
> > +	unsigned char client_digest[MD5_SIGNATURE_SIZE];
> > +	unsigned char server_digest[MD5_SIGNATURE_SIZE];
> > +	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
> > +	struct iscsi_chap *chap = (struct iscsi_chap *) conn->auth_protocol;
> > +	struct crypto_hash *tfm;
> > +	struct hash_desc desc;
> > +	struct scatterlist sg;
> > +	int auth_ret = -1, ret, challenge_len;
> > +
> > +	memset(identifier, 0, 10);
> > +	memset(chap_n, 0, MAX_CHAP_N_SIZE);
> > +	memset(chap_r, 0, MAX_RESPONSE_LENGTH);
> > +	memset(digest, 0, MD5_SIGNATURE_SIZE);
> > +	memset(response, 0, MD5_SIGNATURE_SIZE * 2 + 2);
> > +	memset(client_digest, 0, MD5_SIGNATURE_SIZE);
> > +	memset(server_digest, 0, MD5_SIGNATURE_SIZE);
> > +
> > +	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
> > +	if (!(challenge)) {
> > +		printk(KERN_ERR "Unable to allocate challenge buffer\n");
> > +		return -1;
> 
> this could become "goto out;"
> 

Fixed

> > +	}
> > +
> > +	challenge_binhex = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
> > +	if (!(challenge_binhex)) {
> > +		printk(KERN_ERR "Unable to allocate challenge_binhex buffer\n");
> > +		kfree(challenge);
> > +		return -1;
> 
> and here the kfree() call could go away and the return be converted to 
> "goto out;".
> kfree(0) is a no-op.
> 

Fixed.

> ...
> > +	 * One way authentication has succeeded, return now if mutual
> > +	 * authentication is not enabled.
> > +	 */
> > +	if (!auth->authenticate_target) {
> > +		kfree(challenge);
> > +		kfree(challenge_binhex);
> > +		return 0;
> 
> and here the two kfree() calls would also go away and "return 0" would be 
> replaced with 
> 
> 	auth_ret = 0;
> 	goto out;
> 
> ...
> > +out:
> > +	kfree(challenge);
> > +	kfree(challenge_binhex);
> > +	return auth_ret;
> > +}
> 
> That would nicely consolidate *all* exits from the function in one
> place.
> 
> 

Done.

> 
> > +
> > +int chap_got_response(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_node_auth *auth,
> > +	char *NR_in_ptr,
> > +	char *NR_out_ptr,
> > +	unsigned int *NR_out_len)
> > +{
> > +	struct iscsi_chap *chap = (struct iscsi_chap *) conn->auth_protocol;
> > +
> > +	switch (chap->digest_type) {
> > +	case CHAP_DIGEST_MD5:
> > +		if (chap_server_compute_md5(conn, auth, NR_in_ptr,
> > +				NR_out_ptr, NR_out_len) < 0)
> > +			return -1;
> > +		break;
> > +	default:
> > +		printk(KERN_ERR "Unknown CHAP digest type %d!\n",
> > +				chap->digest_type);
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> 
> You could kill the 'return 0' and replace the 'break' above with 'return 
> 0'. No difference in behaviour, but you'd save a few lines and it would be 
> just as readable IMHO.
> 
> 

Fixed.

Also fixing a handful of 'if (!(foo))' usage and made everything aside
from chap_main_loop() defined as static.

Thanks Jesper!

--nab

