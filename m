From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/26] st: Convert sgl_map_user_pages() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:48 +0200
Message-ID: <1380724087-13927-8-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>
List-Id: linux-scsi@vger.kernel.org

CC: linux-scsi@vger.kernel.org
CC: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/st.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ff44b3c2cff2..ba11299c3740 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4514,19 +4514,11 @@ static int sgl_map_user_pages(struct st_buffer *S=
Tbp,
 	if ((pages =3D kmalloc(max_pages * sizeof(*pages), GFP_KERNEL)) =3D=3D =
NULL)
 		return -ENOMEM;
=20
-        /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
-        /* rw=3D=3DREAD means read from drive, write into memory area */
-	res =3D get_user_pages(
-		current,
-		current->mm,
-		uaddr,
-		nr_pages,
-		rw =3D=3D READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
+        /*
+	 * Try to fault in all of the necessary pages. rw=3D=3DREAD means read
+	 * from drive, write into memory area.
+	 */
+	res =3D get_user_pages_fast(uaddr, nr_pages, rw =3D=3D READ, pages);
=20
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
--=20
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
