From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] iscsi_tcp: Enable any size command
Date: Tue, 13 May 2008 11:52:17 +0300
Message-ID: <482956C1.2030909@panasas.com>
References: <48182A1B.2060102@panasas.com>  <48182E1C.6020905@panasas.com> <1210607224.3078.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20944 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757281AbYEMIxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 04:53:08 -0400
In-Reply-To: <1210607224.3078.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James Bottomley wrote:
> On Wed, 2008-04-30 at 11:30 +0300, Boaz Harrosh wrote:
>> Let through upto the largest command of 260 defined by the scsi standard.
>> iscsi core supports this already. Now that the scsi-ml supports it we can
>> start using large commands.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/scsi/iscsi_tcp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>> index 72b9b2a..826c97c 100644
>> --- a/drivers/scsi/iscsi_tcp.c
>> +++ b/drivers/scsi/iscsi_tcp.c
>> @@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
>>  	.host_template		= &iscsi_sht,
>>  	.conndata_size		= sizeof(struct iscsi_conn),
>>  	.max_conn		= 1,
>> -	.max_cmd_len		= 16,
>> +	.max_cmd_len		= SCSI_MAX_VARLEN_CDB_SIZE,
>>  	/* session management */
>>  	.create_session		= iscsi_tcp_session_create,
>>  	.destroy_session	= iscsi_tcp_session_destroy,
> 
> OK, this isn't quite right.  The escb definition in iscsi.h is:
> struct iscsi_ecdb_ahdr {
> 	__be16 ahslength;	/* CDB length - 15, including reserved byte */
> 	uint8_t ahstype;
> 	uint8_t reserved;
> 	/* 4-byte aligned extended CDB spillover */
> 	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
> };
> 
> Either that 260 needs to become SCSI_MAX_VARLEN_CDB_SIZE or we need to
> hard code 260 in the max_cmd_len.
> 

Yes that 260 needs to become SCSI_MAX_VARLEN_CDB_SIZE. The reason it
is not is because that code is much older than the definition of 
SCSI_MAX_VARLEN_CDB_SIZE.

> Since SCSI_MAX_VARLEN_CDB_SIZE is really a useless constant (nothing
> depends on it), and internal packets in iscsi depend on this, it
> probably makes the most sense for this to be an iscsi local constant.
> 

As you said below, this is not an iscsi limitation it is a scsi 
limitation. Logically it belongs to scsi.h near the varlen definitions.
If you prefer hard coded constants I don't mind, just that from the school
I came from they would fail me if I did that, even for a single user.

> The value (260) also looks a bit bogus, isn't 262 the maximum possible
> size for a 0x7f variable length command?  The iSCSI maxiumum is far
> higher than this (but no protocol sends anything above the 0x7f maximum
> currently).
> 

260 comes from the scsi standard. The 8th byte of a scsi varlen header
is a one byte length specifier. (see struct scsi_varlen_cdb_hdr in scsi.h)
Now the standard says that the header must be 4 bytes aligned so the 
maximum that can be written in that byte is 252, plus the constant 8.
  
> James
> 
> 

Please choose the one you want. Mike I will need your ACK on one of these.

---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 13 Apr 2008 17:52:42 +0300
Subject: [PATCH] iscsi_tcp: Enable any size command

Let through upto the largest command of 260 defined by the scsi standard.
iscsi core supports this already. Now that the scsi-ml supports it we can
start using large commands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.c   |    2 +-
 include/scsi/iscsi_proto.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..826c97c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
-	.max_cmd_len		= 16,
+	.max_cmd_len		= SCSI_MAX_VARLEN_CDB_SIZE,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index e0593bf..f2a2c11 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -22,6 +22,7 @@
 #define ISCSI_PROTO_H
 
 #include <linux/types.h>
+#include <scsi/scsi.h>
 
 #define ISCSI_DRAFT20_VERSION	0x00
 
@@ -156,7 +157,7 @@ struct iscsi_ecdb_ahdr {
 	uint8_t ahstype;
 	uint8_t reserved;
 	/* 4-byte aligned extended CDB spillover */
-	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
+	uint8_t ecdb[SCSI_MAX_VARLEN_CDB_SIZE - ISCSI_CDB_SIZE];
 };
 
 /* SCSI Response Header */
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 13 Apr 2008 17:52:42 +0300
Subject: [PATCH] iscsi_tcp: Enable any size command

Let through upto the largest command of 260 defined by the scsi standard.
iscsi core supports this already. Now that the scsi-ml supports it we can
start using large commands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..073dea7 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
-	.max_cmd_len		= 16,
+	.max_cmd_len		= 260,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,

