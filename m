Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794507728;
	b=ON3NlfpzBxpy+BxLyjqZS+OSlJfSfd2tAQbrJ5uxnZHZW6YkBc28E9Bzq3OFbjExrI0n
	 rBl8AMJcQlYZEVWC8SA5MlYK46ZyGdbs6SiiVcGbJrF2kpcKlWh2Rruf2og03RO5ys2GP
	 fKhNPEcd4uH15N+NOzvwOWSOqJfBzAGEBo5bunAP0T/15ABU4nUBE5BXFEhn2Qe4ASwtY
	 mF0lRWkqVr7qZAhJiRqtGs99UU6G8H/TcldepZEnEOrffCAjpk1mWZ31BI4gK5l6DBCMv
	 HE9ZJF/65yBJUsdXa9jGIhVh1nJIG0lgMKOfY9TYmvbuX+6rtNp8T2KdsjmctKj6low==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794507728;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oLqDOK1wn++paaGO0cvuM15nLhAeIY/Tb/2qpBfiiSk=;
	b=WqlCL+MJ87u4tAzMUigxYE9xwHYNvfeQI9n5V/ukSsqGdNZUwXJkGG/kfS1TyabXOnt3
	 MiOItyJWYU0eROW9Eolp+DR/FsTGQTiVXhr4iao1z9U8ak3UOVyO40qoJB9H2sSXoEGh2
	 429DM9LWSM1IqvjlWoyYNGvakwV4yN1oKxUx+a421BBs+1qofAZKctHHINyCKNTZjgP5l
	 oHUYMS4po1F/oE9ivDNcKK3UqOsEOW/T9Ng03sGhsV0la1lrAUQWN/3nRsoSVroAdF04l
	 Gw+7/asuymyIx40O3o5jBk6+rFT33LMnKTmAUU6yG0kbVTaBent6zIfkiT7yjeZ9Q3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QzdwkSyJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82386606A323;
	Thu, 12 Nov 2026 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QzdwkSyJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2531F000C5;
	Thu, 12 Nov 2026 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507728;
	bh=oLqDOK1wn++paaGO0cvuM15nLhAeIY/Tb/2qpBfiiSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QzdwkSyJepQlosvHP+r8r+gkxkNnnUB2w29n2MC59zPKguX96IhdSOe3OtW7+ZfZ0
	 zvqQ342AOVVFYCKaz1bno2D5aJ65HZpK59Pd9LmkYIy+T2Vt1paxCPvfX30GnLQc9N
	 yL6/SbYxTtC8Pr+1etcpI2H6U+Tn5n5omwheMbj7i0vAKjVMQ8jBRmFI2Qn1S7BDmo
	 mTwo0x2O6IWMFYi3y8Lr+XU8LtggRNwRPCoGHglLsMtmWOWJYV4tbHT8OQ2uvTR9w1
	 Itr2cuT6Oq0pbrO/AKZqe3V47CgWxE/azj9tx6292EZ8yuFqjaCTS4gjIozmWkBsB0
	 v4wvtuAC4PIOg==
Date: Thu, 12 Nov 2026 10:22:07 -0800
From: Kees Cook <kees@kernel.org>
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>
Cc: mkp@kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	morbo@google.com, justinstitt@google.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Replace strlcat() with snprintf()
Message-ID: <202611120959.62EE8ECF@keescook>
References: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>

On Tue, Nov 10, 2026 at 01:31:37AM -0800, Mariia Nikitash wrote:
> In preparation for removing the deprecated strlcat() API[1], replace
> the strlcat() call with snprintf() to construct the AuthMethod value
> directly from param->value.
> 
> Since buf1 contains unmodified copy of param->value, formatting
> original value and suffix together preserves the NUL-terminated
> output, including partial or omitted ",None" suffixes when the
> 256-byte buffer is too small.
> 
> Link: https://github.com/KSPP/linux/issues/370 [1]
> Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
> ---
>  drivers/target/iscsi/iscsi_target_tpg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> index 99772364c88e..aad82a37538f 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -624,7 +624,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)

OMG this whole function makes me weep. Also, I think it has an out of
bounds write in it too:

  echo None > .../tpgt_1/param/AuthMethod
  echo 1    > .../tpgt_1/attrib/authentication

and I don't think it handles the truncation case. This is a good candidate
for a full seq_buf rewrite, IMO.

>  		none = strstr(buf1, NONE);
>  		if (none)
>  			goto out;
> -		strlcat(buf1, "," NONE, sizeof(buf1));
> +		snprintf(buf1, sizeof(buf1), "%s," NONE, param->value);
>  		if (iscsi_update_param_value(param, buf1) < 0)
>  			return -EINVAL;
>  	}

And doesn't need memset either. e.g.:

diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 38d2238dfe08..da720f6be5c1 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -41,7 +41,7 @@ extern int iscsi_change_param_value(char *, struct iscsi_param_list *, int);
 extern void iscsi_release_param_list(struct iscsi_param_list *);
 extern struct iscsi_param *iscsi_find_param_from_key(char *, struct iscsi_param_list *);
 extern int iscsi_extract_key_value(char *, char **, char **);
-extern int iscsi_update_param_value(struct iscsi_param *, char *);
+extern int iscsi_update_param_value(struct iscsi_param *, const char *);
 extern int iscsi_decode_text_input(u8, u8, char *, u32, struct iscsit_conn *);
 extern int iscsi_encode_text_output(u8, u8, char *, u32 *, u32,
 			struct iscsi_param_list *, bool);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 2b318b13268e..34846f5b641c 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -642,7 +642,7 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 	return 0;
 }
 
-int iscsi_update_param_value(struct iscsi_param *param, char *value)
+int iscsi_update_param_value(struct iscsi_param *param, const char *value)
 {
 	kfree(param->value);
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 99772364c88e..6d2cdfa89be5 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -8,6 +8,7 @@
  *
  ******************************************************************************/
 
+#include <linux/seq_buf.h>
 #include <linux/slab.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -579,8 +580,9 @@ int iscsit_tpg_del_network_portal(
 
 int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 {
-	unsigned char buf1[256], buf2[256], *none = NULL;
-	int len;
+	DECLARE_SEQ_BUF(s, 256);
+	char old[256], *p = old, *tok;
+	const char *str;
 	struct iscsi_param *param;
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
@@ -590,44 +592,33 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 		return -EINVAL;
 	}
 
-	memset(buf1, 0, sizeof(buf1));
-	memset(buf2, 0, sizeof(buf2));
-
 	param = iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
 	if (!param)
 		return -EINVAL;
 
 	if (authentication) {
-		snprintf(buf1, sizeof(buf1), "%s", param->value);
-		none = strstr(buf1, NONE);
-		if (!none)
-			goto out;
-		if (!strncmp(none + 4, ",", 1)) {
-			if (!strcmp(buf1, none))
-				sprintf(buf2, "%s", none+5);
-			else {
-				none--;
-				*none = '\0';
-				len = sprintf(buf2, "%s", buf1);
-				none += 5;
-				sprintf(buf2 + len, "%s", none);
-			}
-		} else {
-			none--;
-			*none = '\0';
-			sprintf(buf2, "%s", buf1);
-		}
-		if (iscsi_update_param_value(param, buf2) < 0)
+		/* Remove "None" from the list, unless it is the only entry. */
+		if (strscpy(old, param->value) < 0)
 			return -EINVAL;
+		while ((tok = strsep(&p, ","))) {
+			if (!strcmp(tok, NONE))
+				continue;
+			if (seq_buf_used(&s))
+				seq_buf_putc(&s, ',');
+			seq_buf_puts(&s, tok);
+		}
+		if (!seq_buf_used(&s))
+			goto out;
 	} else {
-		snprintf(buf1, sizeof(buf1), "%s", param->value);
-		none = strstr(buf1, NONE);
-		if (none)
+		if (strstr(param->value, NONE))
 			goto out;
-		strlcat(buf1, "," NONE, sizeof(buf1));
-		if (iscsi_update_param_value(param, buf1) < 0)
-			return -EINVAL;
+		seq_buf_printf(&s, "%s,%s", param->value, NONE);
 	}
+	if (seq_buf_has_overflowed(&s))
+		return -EINVAL;
+	str = seq_buf_str(&s);
+	if (strcmp(str, param->value) && iscsi_update_param_value(param, str) < 0)
+		return -EINVAL;
 
 out:
 	a->authentication = authentication;

-- 
Kees Cook
