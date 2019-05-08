From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 3/3][V3] iio: Handle enumerated properties with gaps
Date: Wed, 8 May 2019 14:19:13 +0300
Message-ID: <20190508111913.7276-3-alexandru.ardelean@analog.com>
References: <20190508111913.7276-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190508111913.7276-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, jic23@kernel.org, lars@metafoo.de, Alexandru Ardelean <alexandru.ardelean@analog.com>
List-Id: linux-scsi@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Some enums might have gaps or reserved values in the middle of their value
range. E.g. consider a 2-bit enum where the values 0, 1 and 3 have a
meaning, but 2 is a reserved value and can not be used.

Add support for such enums to the IIO enum helper functions. A reserved
values is marked by setting its entry in the items array to NULL rather
than the normal descriptive string value.

Also, `__sysfs_match_string()` now supports NULL gaps, so that doesn't
require any changes.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v2 -> v3:
* after fixing __sysfs_match_string(), this change only requires that NULL
  be handled in the iio_enum_{available_}read functions
  __sysfs_match_string() handles the NULL gaps

 drivers/iio/industrialio-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 9c4d92115504..8b4ff3c8f547 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -446,8 +446,11 @@ ssize_t iio_enum_available_read(struct iio_dev *indio_dev,
 	if (!e->num_items)
 		return 0;
 
-	for (i = 0; i < e->num_items; ++i)
+	for (i = 0; i < e->num_items; ++i) {
+		if (!e->items[i])
+			continue;
 		len += scnprintf(buf + len, PAGE_SIZE - len, "%s ", e->items[i]);
+	}
 
 	/* replace last space with a newline */
 	buf[len - 1] = '\n';
@@ -468,7 +471,7 @@ ssize_t iio_enum_read(struct iio_dev *indio_dev,
 	i = e->get(indio_dev, chan);
 	if (i < 0)
 		return i;
-	else if (i >= e->num_items)
+	else if (i >= e->num_items || !e->items[i])
 		return -EINVAL;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", e->items[i]);
-- 
2.17.1
