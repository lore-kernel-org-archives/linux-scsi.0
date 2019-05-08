From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/3][V3] lib: fix __sysfs_match_string() helper when n != -1
Date: Wed, 8 May 2019 14:19:11 +0300
Message-ID: <20190508111913.7276-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, jic23@kernel.org, lars@metafoo.de, Alexandru Ardelean <alexandru.ardelean@analog.com>
List-Id: linux-scsi@vger.kernel.org

The documentation the `__sysfs_match_string()` helper mentions that `n`
(the size of the given array) should be:
 * @n: number of strings in the array or -1 for NULL terminated arrays

The behavior of the function is different, in the sense that it exits on
the first NULL element in the array.

This patch changes the behavior, to exit the loop when a NULL element is
found, and the size of the array is provided as -1.

All current users of __sysfs_match_string() & sysfs_match_string() provide
contiguous arrays of strings, so this behavior change doesn't influence
anything (at this point in time).

This behavior change allows for an array of strings to have NULL elements
within the array, which will be ignored. This is particularly useful when
creating mapping of strings and integers (as bitfields or other HW
description).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v2 -> v3:
* fix __sysfs_match_string() vs adding a new
  __sysfs_match_string_with_gaps() helper

 lib/string.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 3ab861c1a857..5bea3f98478a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -674,8 +674,11 @@ int __sysfs_match_string(const char * const *array, size_t n, const char *str)
 
 	for (index = 0; index < n; index++) {
 		item = array[index];
-		if (!item)
+		if (!item) {
+			if (n != (size_t)-1)
+				continue;
 			break;
+		}
 		if (sysfs_streq(item, str))
 			return index;
 	}
-- 
2.17.1
