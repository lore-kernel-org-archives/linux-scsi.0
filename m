From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/12] adt7470: Check input range when sysfs files are written
Date: Mon, 06 Oct 2008 18:19:19 -0700
Message-ID: <20081007011919.12701.2422.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:51771 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbYJGBTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:19:22 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971JLEH002300
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:21 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971JL6B205570
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:21 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971JKwg025897
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:21 -0600
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7470.c |   77 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index ef26014..5acc800 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -345,6 +345,11 @@ static ssize_t show_temp_min(struct device *dev,
 	return sprintf(buf, "%d\n", 1000 * data->temp_min[attr->index]);
 }
 
+static int range_check(const long val, const long min, const long max)
+{
+	return val >= min && val <= max;
+}
+
 static ssize_t set_temp_min(struct device *dev,
 			    struct device_attribute *devattr,
 			    const char *buf,
@@ -353,7 +358,14 @@ static ssize_t set_temp_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -381,7 +393,14 @@ static ssize_t set_temp_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -430,11 +449,14 @@ static ssize_t set_fan_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	if (!range_check(temp, 0, 65535))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->fan_max[attr->index] = temp;
@@ -465,11 +487,14 @@ static ssize_t set_fan_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	if (!range_check(temp, 0, 65535))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->fan_min[attr->index] = temp;
@@ -507,9 +532,12 @@ static ssize_t set_force_pwm_max(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	mutex_lock(&data->lock);
 	data->force_pwm_max = temp;
 	reg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
@@ -537,7 +565,10 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -564,7 +595,10 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -592,7 +626,10 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -630,7 +667,14 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm_tmin[attr->index] = temp;
@@ -658,11 +702,14 @@ static ssize_t set_pwm_auto(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
 	int pwm_auto_reg = ADT7470_REG_PWM_CFG(attr->index);
 	int pwm_auto_reg_mask;
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	if (attr->index % 2)
 		pwm_auto_reg_mask = ADT7470_PWM2_AUTO_MASK;
 	else
@@ -716,10 +763,14 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = cvt_auto_temp(simple_strtol(buf, NULL, 10));
 	int pwm_auto_reg = ADT7470_REG_PWM_AUTO_TEMP(attr->index);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = cvt_auto_temp(temp);
 	if (temp < 0)
 		return temp;
 

