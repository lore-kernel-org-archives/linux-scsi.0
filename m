From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [scsi-qedf] question about parameter ordering
Date: Wed, 3 May 2017 11:36:34 -0700
Message-ID: <16696718-27c6-b5a6-912d-f5efc592df76@infradead.org>
References: <20170503125818.Horde.8rEDF6U_fTKRV29evjbXFMa@gator4166.hostgator.com>
 <alpine.OSX.2.00.1705031427250.1568@administrators-MacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1705031427250.1568@administrators-MacBook-Pro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 05/03/17 11:29, Chad Dupuis wrote:
> 
> On Wed, 3 May 2017, 1:58pm, Gustavo A. R. Silva wrote:
> 
>>
>> Hello everybody,
>>
>> While looking into Coverity ID 1402011 I ran into the following piece of code
>> at drivers/scsi/qedf/qedf_io.c:2057:
>>
>> /* Fill FC header */
>> fc_hdr = &(tm_req->req_fc_hdr);
>> sid = fcport->sid;
>> did = fcport->rdata->ids.port_id;
>> __fc_fill_fc_hdr(fc_hdr, FC_RCTL_DD_UNSOL_CMD, sid, did,
>>                   FC_TYPE_FCP, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
>>                   FC_FC_SEQ_INIT, 0);
>>
>> The issue here is that the position of arguments in the call to
>> __fc_fill_fc_hdr() function do not match the ordering of the parameters:
>>
>> _sid_ is passed to _did_
>> _did_ is passed to _sid_
>>
>> this is the function prototype:
>>
>> static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
>>                                    enum fc_rctl r_ctl,
>>                                    u32 did, u32 sid, enum fc_fh_type type,
>>                                    u32 f_ctl, u32 parm_offset)
>>
>> My question here is if this is intentionala?
> 
> This may have been but this code has been superseded by commit 	
> be086e7c53f1fac51eed14523b28f2214b548dd2.B

what git tree is that in?

Thanks.

>> In case it is not, I will send a patch to fix it. But first it would be great
>> to hear any comment about it.
>>
>> By the way... the same is happening at drivers/scsi/qedf/qedf_els.c:109
> 
> May be a bug here so you could send a patch.


-- 
~Randy
