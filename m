From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi: qedf: replace memset/memcpy with safer strscpy
Date: Fri, 12 Apr 2019 10:23:44 +0100
Message-ID: <6d39b8e9-c78b-ebf1-92c1-8b2865b90680@canonical.com>
References: <20190412090552.26925-1-colin.king@canonical.com>
 <5ad7aee7-0c0b-5d1d-e40d-39e8bbe5e841@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ad7aee7-0c0b-5d1d-e40d-39e8bbe5e841@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/04/2019 10:20, YueHaibing wrote:
> 
> I send a similar fix earlier, but it seems not be picked.

It would be useful to get a fix for this applied as I'm seeing many
multiple of reports of this issue with Coverity and it is a relatively
simple fix.

Colin

> 
> https://patchwork.kernel.org/patch/10874565/
> 
> On 2019/4/12 17:05, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the qedf_dbg_* family of functions can overrun the end
>> of the source string if it is less than the destination buffer
>> length because of the use of a fixed sized memcpy. Replace the
>> memset/memcpy calls with the safer strscpy as this won't overrun
>> the end of the source string and it ensures the destination
>> string is always terminated with NUL.
>>
>> Addresses-Coverity: ("Out-of-bounds access")
>> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/scsi/qedf/qedf_dbg.c | 12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
>> index f2397ee9ba69..b491bebeaca9 100644
>> --- a/drivers/scsi/qedf/qedf_dbg.c
>> +++ b/drivers/scsi/qedf/qedf_dbg.c
>> @@ -17,8 +17,7 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>>  	struct va_format vaf;
>>  	char nfunc[32];
>>  
>> -	memset(nfunc, 0, sizeof(nfunc));
>> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
>> +	strscpy(nfunc, func, sizeof(nfunc));
>>  
>>  	va_start(va, fmt);
>>  
>> @@ -42,8 +41,7 @@ qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>>  	struct va_format vaf;
>>  	char nfunc[32];
>>  
>> -	memset(nfunc, 0, sizeof(nfunc));
>> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
>> +	strscpy(nfunc, func, sizeof(nfunc));
>>  
>>  	va_start(va, fmt);
>>  
>> @@ -71,8 +69,7 @@ qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>>  	struct va_format vaf;
>>  	char nfunc[32];
>>  
>> -	memset(nfunc, 0, sizeof(nfunc));
>> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
>> +	strscpy(nfunc, func, sizeof(nfunc));
>>  
>>  	va_start(va, fmt);
>>  
>> @@ -101,8 +98,7 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
>>  	struct va_format vaf;
>>  	char nfunc[32];
>>  
>> -	memset(nfunc, 0, sizeof(nfunc));
>> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
>> +	strscpy(nfunc, func, sizeof(nfunc));
>>  
>>  	va_start(va, fmt);
>>  
>>
> 
