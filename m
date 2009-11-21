From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Subject: [PATCH 1/4] ibmvscsi: remove redundant zero fill
Date: Sat, 21 Nov 2009 23:09:58 +0100
Message-ID: <4B086536.7080402@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756863AbZKUWKD@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Boutcher <boutcher@us.ibm.com>, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxie@us.ibm.com>, FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org
Cc: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>

The buffer is first zeroed out by memset(). Then strncpy() is used to
fill the content. The strncpy() function also pads the string till the
end of the specified length, which is redundant. The strncpy() does not
ensures that the string will be properly closed with 0. Use strlcpy()
instead.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression buffer;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer, str, sizeof(buffer)
	);
@@
expression buffer;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	&buffer, str, sizeof(buffer));
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer->field, str, sizeof(buffer->field)
	);
@@
expression buffer;
identifier field;
expression size;
expression str;
@@
	memset(&buffer, 0, size);
	...
-	strncpy(
+	strlcpy(
	buffer.field, str, sizeof(buffer.field));
// </smpl>

On strncpy() vs strlcpy() see http://www.gratisoft.us/todd/papers/strlc=
py.html .

Signed-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>
---
diff -u -p a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/i=
bmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c 2009-09-10 00:13:59.000000000 +0=
200
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c 2009-11-21 22:10:13.000000000 +0=
100
@@ -339,7 +339,7 @@ int send_adapter_info(struct iu_entry *i
 	memset(info, 0, sizeof(*info));

 	strcpy(info->srp_version, "16.a");
-	strncpy(info->partition_name, partition_name,
+	strlcpy(info->partition_name, partition_name,
 		sizeof(info->partition_name));
 	info->partition_number =3D partition_number;
 	info->mad_version =3D 1;
diff -u -p a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/=
rpa_vscsi.c
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c 2009-09-10 00:13:59.000000000 +=
0200
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c 2009-11-21 22:10:15.000000000 +=
0100
@@ -181,7 +181,7 @@ static void set_adapter_info(struct ibmv
 	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
 	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);

-	strncpy(hostdata->madapter_info.partition_name, partition_name,
+	strlcpy(hostdata->madapter_info.partition_name, partition_name,
 			sizeof(hostdata->madapter_info.partition_name));

 	hostdata->madapter_info.partition_number =3D partition_number;
