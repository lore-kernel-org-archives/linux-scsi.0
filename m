From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] b2iscsi: Fix memory leak in mgmt_set_ip()
Date: Fri, 27 Jun 2014 21:38:10 +0200
Message-ID: <53ADC822.1040508@redhat.com>
References: <1403873720-9642-1-git-send-email-mlombard@redhat.com> <53AD9C8A.7010007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaF0Tj5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 15:39:57 -0400
In-Reply-To: <53AD9C8A.7010007@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hch@infradead.org, JBottomley@parallels.com



>> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
>> index 07934b0..a3e5648 100644
>> --- a/drivers/scsi/be2iscsi/be_mgmt.c
>> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
>> @@ -1015,7 +1015,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
>>  		if (if_info->dhcp_state) {
>>  			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
>>  				    "BG_%d : DHCP Already Enabled\n");
>> -			return 0;
>> +			goto exit;
> 
> rc should be initialised - so this needs to be added to your patch

It is initialized at the beginning of the function, and it must contain zero when the "goto exit" is executed.

int mgmt_set_ip(struct beiscsi_hba *phba,
                struct iscsi_iface_param_info *ip_param,
                struct iscsi_iface_param_info *subnet_param,
                uint32_t boot_proto)
{
        struct be_cmd_get_def_gateway_resp gtway_addr_set;
        struct be_cmd_get_if_info_resp *if_info;
        struct be_cmd_set_dhcp_req *dhcpreq;
        struct be_cmd_rel_dhcp_req *reldhcp;
        struct be_dma_mem nonemb_cmd;
        uint8_t *gtway_addr;
        uint32_t ip_type;
        int rc;

        if (mgmt_get_all_if_id(phba))
                return -EIO;

        ip_type = (ip_param->param == ISCSI_NET_PARAM_IPV6_ADDR) ?
                BE2_IPV6 : BE2_IPV4 ;

        rc = mgmt_get_if_info(phba, ip_type, &if_info); <-------------- here
        if (rc)
                return rc;

        if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
                if (if_info->dhcp_state) {
                        beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
                                    "BG_%d : DHCP Already Enabled\n");
                        goto exit;
                }

Regards,
Maurizio Lombardi
