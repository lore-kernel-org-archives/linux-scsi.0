From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/13] qla4xxx: Fixed device blocked issue on link up-down.
Date: Mon, 03 Oct 2011 16:16:15 -0500
Message-ID: <4E8A261F.9080803@cs.wisc.edu>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com> <1317662967-30110-10-git-send-email-vikas.chaudhary@qlogic.com> <4E8A22AA.70500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050007030506060309030307"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50046 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1JCVLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 17:11:05 -0400
In-Reply-To: <4E8A22AA.70500@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

This is a multi-part message in MIME format.
--------------050007030506060309030307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/03/2011 04:01 PM, Mike Christie wrote:
> On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
>> From: Manish Rangankar <manish.rangankar@qlogic.com>
>>
>> Devices are getting blocked during continuous link up and down. Solution is,
>> during relogin unblock the session before sending connection logged in event.
>>
>> JIRA Key: UPSISCSI-138
>>
>> Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
>> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>> ---
>>  drivers/scsi/qla4xxx/ql4_init.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
>> index cc10bac..e07d99b 100644
>> --- a/drivers/scsi/qla4xxx/ql4_init.c
>> +++ b/drivers/scsi/qla4xxx/ql4_init.c
>> @@ -900,6 +900,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>>  		switch (state) {
>>  		case DDB_DS_SESSION_ACTIVE:
>>  		case DDB_DS_DISCOVERY:
>> +			iscsi_unblock_session(ddb_entry->sess);
> 
> Shouldn't this alreadu get done when start_conn callback is called?
> 
> Is the problem that start_conn is getting called when login is started
> and not when we are actually logged in (when we get the logged in event
> below)?
> 
> The start_conn callback use looks wrong right now for qla4xxx.
> user/initiator.c:setup_offload_login_phase() will call it when we are
> only in_login. It should only be called when we are logged_in, because
> it will unlbock the devices, update the iscsi session state and could
> start IO before the driver is ready.
> 

One clarification. Qla4xxx needs to do its setup in there but it should
not call iscsi_conn_start until it is actually logged in.

I think we want to do like the attached (patch not even compile tested).
It is built over this patch and 10/13.


--------------050007030506060309030307
Content-Type: text/plain;
 name="qla4xxx-start-conn.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qla4xxx-start-conn.patch"

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index e07d99b..3075fba 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -900,7 +900,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
-			iscsi_unblock_session(ddb_entry->sess);
+			iscsi_conn_start(ddb_entry->conn);
 			iscsi_conn_login_event(ddb_entry->conn,
 					       ISCSI_CONN_STATE_LOGGED_IN);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
@@ -936,6 +936,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
+			iscsi_conn_start(ddb_entry->conn);
 			iscsi_conn_login_event(ddb_entry->conn,
 					       ISCSI_CONN_STATE_LOGGED_IN);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f84ddd2..676aedc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1136,7 +1136,7 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		if (mbx_sts)
 			if (ddb_entry->fw_ddb_device_state ==
 						DDB_DS_SESSION_ACTIVE) {
-				iscsi_unblock_session(ddb_entry->sess);
+				iscsi_conn_start(ddb_entry->conn);
 				iscsi_conn_login_event(ddb_entry->conn,
 						ISCSI_CONN_STATE_LOGGED_IN);
 				goto exit_set_param;
@@ -1162,7 +1162,6 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		      ddb_entry->fw_ddb_device_state));
 
 exit_set_param:
-	iscsi_conn_start(cls_conn);
 	ret = 0;
 
 exit_conn_start:

--------------050007030506060309030307--
