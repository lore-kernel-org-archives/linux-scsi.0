From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH RESEND] libosd: Remove ignored __weak attribute
Date: Fri, 25 Jan 2019 23:47:41 -0700
Message-ID: <20190126064740.12949-1-natechancellor@gmail.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930205448.26205-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns that the __weak attribute is going to be ignored on
osd_root_object because it's not in the correct location (needs to be
after the type).

./include/scsi/osd_types.h:31:21: warning: 'weak' attribute only applies
to variables, functions, and classes [-Wignored-attributes]
static const struct __weak osd_obj_id osd_root_object = {0, 0};
                    ^

Turns out that GCC ignores the attribute too albeit silently because
moving the attribute after either osd_obj_id or osd_root_object like
all other uses of __weak on variables in the kernel causes a build
error on both GCC and Clang because static variables cannot be weak
since weak definitions rely on not having internal linkage:

./include/scsi/osd_types.h:31:32: error: weak declaration cannot have
internal linkage
static const struct osd_obj_id __weak osd_root_object = {0, 0};
                               ^

Just remove the attribute because it hasn't been correct since the
initial addition of this file in commit de258bf5e638 ("[SCSI] libosd:
OSDv1 Headers").

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Resending as there was no conclusion on the removal of the OSD code and
this warning is still present on mainline/next. I think it is rather
unfair for this patch to be held back because of the possibility of
removing this code when it is a very simple clean up patch and doesn't
affect anything other than a build time warning. If this declaration or
driver needs to be cleaned up in other ways, it should be done in
subsequent patches.

Thanks,
Nathan

 include/scsi/osd_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
index 48e8a165e136..6b6fdcafa6cc 100644
--- a/include/scsi/osd_types.h
+++ b/include/scsi/osd_types.h
@@ -28,7 +28,7 @@ struct osd_obj_id {
 	osd_id id;
 };
 
-static const struct __weak osd_obj_id osd_root_object = {0, 0};
+static const struct osd_obj_id osd_root_object = {0, 0};
 
 struct osd_attr {
 	u32 attr_page;
-- 
2.20.1
