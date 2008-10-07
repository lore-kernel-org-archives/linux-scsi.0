From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 12/12] adt7473: Check inputs from sysfs writes
Date: Mon, 06 Oct 2008 18:19:25 -0700
Message-ID: <20081007011925.12701.88807.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37975 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYJGBT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:19:57 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971June010810
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971JuAs197486
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:56 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971JtEW029758
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:56 -0600
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7473.c |   96 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 3a0b631..b4bcb63 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -360,6 +360,11 @@ static ssize_t show_volt_min(struct device *dev,
 		       decode_volt(attr->index, data->volt_min[attr->index]));
 }
 
+static int range_check(const long val, const long min, const long max)
+{
+	return val >= min && val <= max;
+}
+
 static ssize_t set_volt_min(struct device *dev,
 			    struct device_attribute *devattr,
 			    const char *buf,
@@ -368,7 +373,14 @@ static ssize_t set_volt_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
+	if (!range_check(volt, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->volt_min[attr->index] = volt;
@@ -397,7 +409,14 @@ static ssize_t set_volt_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
+	if (!range_check(volt, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->volt_max[attr->index] = volt;
@@ -452,8 +471,15 @@ static ssize_t set_temp_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
 	temp = encode_temp(data->temp_twos_complement, temp);
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -483,8 +509,15 @@ static ssize_t set_temp_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
 	temp = encode_temp(data->temp_twos_complement, temp);
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -526,11 +559,14 @@ static ssize_t set_fan_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
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
@@ -569,7 +605,10 @@ static ssize_t set_max_duty_at_crit(struct device *dev,
 	u8 reg;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = !!temp;
@@ -598,7 +637,10 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -625,7 +667,10 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -653,7 +698,10 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp) || !range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -683,8 +731,15 @@ static ssize_t set_temp_tmax(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
 	temp = encode_temp(data->temp_twos_complement, temp);
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_tmax[attr->index] = temp;
@@ -714,8 +769,15 @@ static ssize_t set_temp_tmin(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp /= 1000;
 	temp = encode_temp(data->temp_twos_complement, temp);
+	if (!range_check(temp, 0, 255))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->temp_tmin[attr->index] = temp;
@@ -752,7 +814,10 @@ static ssize_t set_pwm_enable(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 0:
@@ -816,7 +881,10 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 1:

