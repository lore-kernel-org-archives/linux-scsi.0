From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] dmraid: set read_info to @offset by default
	in read_raid_dev()
Date: Sun, 01 Feb 2009 12:00:07 +0900
Message-ID: <49851037.1090203@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	<49851012.8070904@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49851012.8070904@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
List-Id: linux-scsi@vger.kernel.org

read_info is passed from optional f_read_metatdata() to f_setup_rd().
If f_read_metadata() doesn't exist or doesn't initialize it, read_info
contains garbage.  Initialize it to @offset by default.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/format/format.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/format/format.c b/lib/format/format.c
index 88cb938..4a2594a 100644
--- a/lib/format/format.c
+++ b/lib/format/format.c
@@ -435,7 +435,7 @@ read_raid_dev(struct lib_context *lc,
 {
 	struct raid_dev *rd = NULL;
 	void *meta;
-	union read_info info;
+	union read_info info = { .u64 = offset };
 
 	/*
 	 * In case the metadata format handler provides a special
-- 
1.6.0.2
