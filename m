From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [BUG] scsi: ses: out of bound accessing in
 ses_enclosure_data_process
Date: Tue, 19 Mar 2019 10:41:58 +0800
Message-ID: <92bf2380-626c-d51a-3f8b-de30462d4dd3@oracle.com>
References: <78dd3eca-7e8a-72f9-07f9-e2c7cc4569b0@oracle.com>
 <yq1k1gwkc6x.fsf@oracle.com>
 <3b2542225e519a8cf8e329745b0ee2e2464787c7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3b2542225e519a8cf8e329745b0ee2e2464787c7.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.ibm.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, diego.gonzalez@oracle.com
List-Id: linux-scsi@vger.kernel.org



On 3/18/19 11:22 PM, Ewan D. Milne wrote:
> On Mon, 2019-03-18 at 01:01 -0400, Martin K. Petersen wrote:
>> Jianchao,
>>
>>> When our customer probe the lpfc devices, they encountered odd memory
>>> corruption issues, and we get 'out of bound' access warning at
>>> following position after open KASAN
>>
>> Please provide the output of:
>>
>> # sg_ses -p 1 /dev/sgN
>> # sg_ses -p 7 /dev/sgN
>>
>> for the enclosure device in question.
>>
> 
> The ses driver is allocating kernel buffers based upon the size
> reported by RECEIVE DIAGNOSTIC commands, and is iterating through
> them based on sizes in the individual descriptors.  It appears to
> be vulnerable to incorrect data from the device causing out-of-bounds
> memory access, because the for() test does not prevent the use of
> the pointer in subsequent code, e.g.:
> 
>         for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
>                 types += type_ptr[2];
>                 type_ptr += type_ptr[3] + 4;
>         }
> 
>         ses_dev->page1_types = type_ptr;
>         ses_dev->page1_num_types = types;
> 
> Whether or not this is the current problem, it's wrong.
> 

Yes, I definitely agree with this.
There should be some change here.

Thanks
Jianchao
