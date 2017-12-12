From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/8] target/iscsi: Move resetting of seven variables in
 chap_server_compute_md5()
Date: Tue, 12 Dec 2017 22:43:59 +0100
Message-ID: <8566665c-8d90-ed92-2781-c4b2dde2a95d@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 19:43:47 +0100

Move the resetting of these array variables so that this operation will
be performed only if memory allocations succeeded before in this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_auth.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 94b011fe74e8..d837fcbdbaf2 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -197,14 +197,6 @@ static int chap_server_compute_md5(
 	struct shash_desc *desc;
 	int auth_ret = -1, ret, challenge_len;
 
-	memset(identifier, 0, 10);
-	memset(chap_n, 0, MAX_CHAP_N_SIZE);
-	memset(chap_r, 0, MAX_RESPONSE_LENGTH);
-	memset(digest, 0, MD5_SIGNATURE_SIZE);
-	memset(response, 0, MD5_SIGNATURE_SIZE * 2 + 2);
-	memset(client_digest, 0, MD5_SIGNATURE_SIZE);
-	memset(server_digest, 0, MD5_SIGNATURE_SIZE);
-
 	challenge = kzalloc(CHAP_CHALLENGE_STR_LEN, GFP_KERNEL);
 	if (!challenge) {
 		pr_err("Unable to allocate challenge buffer\n");
@@ -216,6 +208,9 @@ static int chap_server_compute_md5(
 		pr_err("Unable to allocate challenge_binhex buffer\n");
 		goto free_challenge;
 	}
+
+	memset(chap_n, 0, MAX_CHAP_N_SIZE);
+
 	/*
 	 * Extract CHAP_N.
 	 */
@@ -236,6 +231,8 @@ static int chap_server_compute_md5(
 		goto free_challenge_binhex;
 	}
 	pr_debug("[server] Got CHAP_N=%s\n", chap_n);
+	memset(chap_r, 0, MAX_RESPONSE_LENGTH);
+
 	/*
 	 * Extract CHAP_R.
 	 */
@@ -250,6 +247,7 @@ static int chap_server_compute_md5(
 	}
 
 	pr_debug("[server] Got CHAP_R=%s\n", chap_r);
+	memset(client_digest, 0, MD5_SIGNATURE_SIZE);
 	chap_string_to_hex(client_digest, chap_r, strlen(chap_r));
 
 	tfm = crypto_alloc_shash("md5", 0, 0);
@@ -286,6 +284,7 @@ static int chap_server_compute_md5(
 		goto free_desc;
 	}
 
+	memset(server_digest, 0, MD5_SIGNATURE_SIZE);
 	ret = crypto_shash_finup(desc, chap->challenge,
 				 CHAP_CHALLENGE_LENGTH, server_digest);
 	if (ret < 0) {
@@ -293,6 +292,7 @@ static int chap_server_compute_md5(
 		goto free_desc;
 	}
 
+	memset(response, 0, MD5_SIGNATURE_SIZE * 2 + 2);
 	chap_binaryhex_to_asciihex(response, server_digest, MD5_SIGNATURE_SIZE);
 	pr_debug("[server] MD5 Server Digest: %s\n", response);
 
@@ -310,6 +310,9 @@ static int chap_server_compute_md5(
 		auth_ret = 0;
 		goto free_desc;
 	}
+
+	memset(identifier, 0, ARRAY_SIZE(identifier));
+
 	/*
 	 * Get CHAP_I.
 	 */
@@ -393,6 +396,9 @@ static int chap_server_compute_md5(
 				" password_mutual\n");
 		goto free_desc;
 	}
+
+	memset(digest, 0, MD5_SIGNATURE_SIZE);
+
 	/*
 	 * Convert received challenge to binary hex.
 	 */
-- 
2.15.1
