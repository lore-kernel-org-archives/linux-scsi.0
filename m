From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/2] libfc: fix mem leak in fc_tm_done()
Date: Wed, 27 Oct 2010 20:55:09 -0500
Message-ID: <4CC8D7FD.3070608@cs.wisc.edu>
References: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
	<1288229055.1431.46.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1288229055.1431.46.camel@fritz>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2010 08:24 PM, Robert Love wrote:
> On Mon, 2010-10-25 at 20:37 +0800, Hillf Danton wrote:
>> There seems frame should get freed against memory leakage.
>>
>> Signed-off-by: Hillf Danton<dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-25 20:31:04.000000000 +0800
>> @@ -1294,6 +1294,7 @@ static void fc_tm_done(struct fc_seq *se
>>   	 */
>>   	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
>>   		spin_unlock_bh(&fsp->scsi_pkt_lock);
>
> I wonder if this should be a fc_fcp_unlock_pkt(fsp) since we get the
> lock with the fc_fcp_lock_pkt(fsp) call above.
>

Did I do that. I think you are right. Not sure what happened if it was me.
