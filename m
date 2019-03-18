From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [BUG] scsi: ses: out of bound accessing in
 ses_enclosure_data_process
Date: Mon, 18 Mar 2019 12:17:27 +0800
Message-ID: <b193ebee-5ea0-0041-aff2-570065a328b4@oracle.com>
References: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com>
 <40646609-8298-2d76-2f0c-e732404a23d4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <40646609-8298-2d76-2f0c-e732404a23d4@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com
Cc: "jianchao.wang" <jianchao.w.wang@oracle.com>, jejb@linux.ibm.com, martin.petersen@oracle.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, diego.gonzalez@oracle.com
List-Id: linux-scsi@vger.kernel.org

Add lpfc maintainer James & Dick.  Could you help take a look?

Thanks,

Junxiao.

On 3/18/19 11:13 AM, jianchao.wang wrote:
> Would anyone please give some suggestions ?
>
> It looks like there somethings wrong in the read-in data,
>
> 	/* skip all the enclosure descriptors */
> 	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
> 		types += type_ptr[2];
> 		type_ptr += type_ptr[3] + 4; ----> here
> 	}
> Then the typr_ptr got out of bound of the buffer.
>
>
> Thanks
> Jianchao
>
> On 3/14/19 11:19 AM, jianchao.wang wrote:
>> Dear all
>>
>> When our customer probe the lpfc devices, they encountered odd memory corruption issues,
>> and we get 'out of bound' access warning at following position after open KASAN
>>
>> ses_enclosure_data_process
>>
>> for (i = 0; i < types; i++, type_ptr += 4) {
>>    for (j = 0; j < type_ptr[1]; j++) {
>>                     ^^^^^^^^^^^
>>                     out of bound
>>
>> With some debug log, I got following,
>>
>> page1 ffff88042d1aad20 len 32 types 5 type_ptr ffff88042d1aad64
>>
>> Would anyone please give some suggestions on this ?
>>
>> Thanks
>> Jianchao
>>
