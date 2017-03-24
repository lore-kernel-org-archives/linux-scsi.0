From: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Subject: Re: [PATCH] lsscsi: Fix truncation of 128-bit wwn
Date: Fri, 24 Mar 2017 09:48:36 +0530
Message-ID: <877f3fgvdv.fsf@vajain21.in.ibm.com>
References: <20170317043840.26560-1-vaibhav@linux.vnet.ibm.com> <20170317102849.GA2719@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751255AbdCXETu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Mar 2017 00:19:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2O4Dfm9024631
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 00:19:49 -0400
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29c0uje0p8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 00:19:49 -0400
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <vaibhav@linux.vnet.ibm.com>;
        Fri, 24 Mar 2017 14:19:46 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2O4JXa233030206
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 15:19:41 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2O4J6iV016654
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 15:19:06 +1100
In-Reply-To: <20170317102849.GA2719@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gris Ge <fge@redhat.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jon Grimm <jon.grimm@canonical.com>, Vipin K Parashar <vipin@linux.vnet.ibm.com>, Ping Tian Han <pthan@cn.ibm.com>

Hi Gris,

Thanks for reviewing the patch. I have posted a v2 patch addressing your
review comments. Can you please take a look.

Patch-Link:
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg59720.html

Gris Ge <fge@redhat.com> writes:

> On Fri, Mar 17, 2017 at 10:08:40AM +0530, Vaibhav Jain wrote:
>> ---
>>  src/lsscsi.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/src/lsscsi.c b/src/lsscsi.c
>> index 974b3f1..f20adcf 100644
>> --- a/src/lsscsi.c
>> +++ b/src/lsscsi.c
>> @@ -210,8 +210,8 @@ struct dev_node_list {
>>  static struct dev_node_list* dev_node_listhead = NULL;
>>  
>>  struct disk_wwn_node_entry {
>> -       char wwn[32];
>> -       char disk_bname[12];
>> +	char wwn[35]; /* '0x' + wwn<128-bit> + <null-terminator> */
> Please consider to define a constant instead of using a magic number
> everywhere. Like:
> #define _DISK_WWN_MAX_LEN           35
> /* ^ WWN here is extracted from /dev/disk/by-id/wwn-<WWN> which is
>  *   created by udev 60-persistent-storage.rules using ID_WWN_WITH_EXTENSION.
>  *   The udev ID_WWN_WITH_EXTENSION is the combination of char wwn[17] and
>  *   char wwn_vendor_extension[17] from struct scsi_id_device.
>  */
>> +	char disk_bname[12];
> Please use space instead of \t for indention.
>>  };
>>  
>>  #define DISK_WWN_NODE_LIST_ENTRIES 16
>> @@ -2939,14 +2939,14 @@ one_sdev_entry(const char * dir_name, const char * devname,
>>                  }
>>                  if (wd[0]) {
>>                          char dev_node[LMAX_NAME] = "";
>> -                        char wwn_str[34];
>> +			char wwn_str[35];
> Please use space instead of \t for indention.
>>                          enum dev_type typ;
>>  
>>                          typ = (FT_BLOCK == non_sg.ft) ? BLK_DEV : CHR_DEV;
>>                          if (get_wwn) {
>>                                  if ((BLK_DEV == typ) &&
>>                                      get_disk_wwn(wd, wwn_str, sizeof(wwn_str)))
>> -                                        printf("%-30s  ", wwn_str);
>> +					printf("%-34s  ", wwn_str);
> Please use constant instead of magic number:
>     printf("%-*s  ", _DISK_WWN_MAX_LEN - 1, wwn_str);
>>                                  else
>>                                          printf("                          "
>>                                                 "      ");
>> -- 
>> 2.9.3
>> 
>
> -- 
> Gris Ge

-- 
Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Linux Technology Center, IBM India Pvt. Ltd.
