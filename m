From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 032/189] scsi: target: fix crash with iscsi target and dvd
Date: Mon, 18 Jun 2018 10:12:08 +0200
Message-ID: <20180618081210.570362465@linuxfoundation.org>
References: <20180618081209.254234434@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618081209.254234434@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Wakko Warner <wakko@animx.eu.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8e1ceafe50ec4d1bcfae154dd70e7cb6946a6177 ]

When the current page can't be added to bio, one new bio should be
created for adding this page again, instead of ignoring this page.

This patch fixes kernel crash with iscsi target and dvd, as reported by
Wakko.

Cc: Wakko Warner <wakko@animx.eu.org>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 84c8590646d5b35804 ("target: avoid accessing .bi_vcnt directly")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_pscsi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -890,6 +890,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct
 			bytes = min(bytes, data_len);
 
 			if (!bio) {
+new_bio:
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 				/*
@@ -931,6 +932,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct
 				 * be allocated with pscsi_get_bio() above.
 				 */
 				bio = NULL;
+				goto new_bio;
 			}
 
 			data_len -= bytes;
