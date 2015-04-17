From: Sony John-N <Sony.John-N@Emulex.Com>
Subject: RE: [PATCH 6/7] be2iscsi: Logout of FW Boot Session
Date: Fri, 17 Apr 2015 10:44:10 +0000
Message-ID: <8c988ab9-d54c-4c34-a35c-6643509c58aa@CMEXHTCAS1.ad.emulex.com>
References: <81b67d78-0558-4d7e-bce7-16ccf9d7064f@CMEXHTCAS2.ad.emulex.com>
 <553012E6.7050707@cs.wisc.edu> <553016F2.9040204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:8317 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbDQKon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 06:44:43 -0400
In-Reply-To: <553016F2.9040204@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Friday, April 17, 2015 1:39 AM
To: Sony John-N; linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal
Subject: Re: [PATCH 6/7] be2iscsi: Logout of FW Boot Session

On 04/16/2015 02:52 PM, Mike Christie wrote:
> On 04/17/2015 04:34 AM, John Soni Jose wrote:
>>  Once be2iscsi driver is loaded and operational close Boot  session 
>> established by FW.
>>
>> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
>> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>> ---
>>  drivers/scsi/be2iscsi/be_cmds.h  |   12 ++++++
>>  drivers/scsi/be2iscsi/be_iscsi.c |   12 ++++++
>>  drivers/scsi/be2iscsi/be_main.c  |    1 +
>>  drivers/scsi/be2iscsi/be_main.h  |    2 +
>>  drivers/scsi/be2iscsi/be_mgmt.c  |   70 ++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/be2iscsi/be_mgmt.h  |    3 ++
>>  6 files changed, 100 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_cmds.h 
>> b/drivers/scsi/be2iscsi/be_cmds.h index d0097a2..0586815 100644
>> --- a/drivers/scsi/be2iscsi/be_cmds.h
>> +++ b/drivers/scsi/be2iscsi/be_cmds.h
>> @@ -304,6 +304,17 @@ struct mgmt_auth_method_format {
>>  	struct	mgmt_chap_format chap;
>>  } __packed;
>>  
>> +struct be_cmd_req_logout_fw_sess {
>> +	struct be_cmd_req_hdr hdr;	/* dw[4] */
>> +	uint32_t session_handle;
>> +} __packed;
>> +
>> +struct be_cmd_resp_logout_fw_sess {
>> +	struct be_cmd_resp_hdr hdr;	/* dw[4] */
>> +#define BEISCSI_MGMT_SESSION_CLOSE 0x20
>> +	uint32_t session_status;
>> +} __packed;
>> +
>>  struct mgmt_conn_login_options {
>>  	u8 flags;
>>  	u8 header_digest;
>> @@ -1136,6 +1147,7 @@ struct be_cmd_get_all_if_id_req {
>>  #define OPCODE_ISCSI_INI_CFG_GET_HBA_NAME	6
>>  #define OPCODE_ISCSI_INI_CFG_SET_HBA_NAME	7
>>  #define OPCODE_ISCSI_INI_SESSION_GET_A_SESSION  14
>> +#define OPCODE_ISCSI_INI_SESSION_LOGOUT_TARGET	 24
>>  #define OPCODE_ISCSI_INI_DRIVER_REOPEN_ALL_SESSIONS 36  #define 
>> OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41  #define 
>> OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42 diff --git 
>> a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
>> index 508f017..566d27c 100644
>> --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> @@ -998,6 +998,18 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
>>  	beiscsi_set_params_for_offld(beiscsi_conn, &params);
>>  	beiscsi_offload_connection(beiscsi_conn, &params);
>>  	iscsi_conn_start(cls_conn);
>> +
>> +	/* Logout from the FW boot session */
>> +	if (phba->fw_boot_state) {
>> +		int rc;
>> +
>> +		rc = beiscsi_logout_fw_sess(phba,
>> +			phba->boot_sess.session_handle);
>> +
>> +		if (!rc)
>> +			phba->fw_boot_state = 0
>> +	}
>> +
>>  	return 0;
>>  }
> 
> How do you know the boot session being logged out is the one we are 
> replacing and logging into at this time? If userspace logged into 
> sessions out of order and you logged into a non root one first, then 
> would this kill the session that we might need to access still?

Ignore that, I forgot we get the boot info a pci probe time or from the health check. But the, why not just have beiscsi_setup_boot_info log out the session once its done getting the boot info?
It just seems odd to have that logout in the middle of the connection startup.

We  called logout from here to make sure that FW boot-Session would have completed the IO's and only NOP-IN/NOP-OUT are going on. Beiscsi_setup_boot_info was called from probe(), so thought it will be too early for issuing logout to FW boot-session.

