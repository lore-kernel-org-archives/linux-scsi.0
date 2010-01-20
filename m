From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: Fix printing of variable length commands
Date: Wed, 20 Jan 2010 11:20:09 +0200
Message-ID: <4B56CAC9.2060703@panasas.com>
References: <yq1aawbt3rr.fsf@sermon.lab.mkp.net> <4B558030.90006@panasas.com> <yq1wrzdkzxn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35002 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490Ab0ATJUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 04:20:12 -0500
In-Reply-To: <yq1wrzdkzxn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@ORACLE.COM>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/20/2010 09:17 AM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> If you are already at it could you also add the things that
> Boaz> bothered me? I did stare at this function before, but did not see
> Boaz> the bug you are fixing, thanks.  (Did see other less important
> Boaz> stuff)
> 
> I'm ok with cleaning up the redundant statements even though it's a bit
> of churn in what's otherwise a pure bug fix patch.  Simply on the
> grounds that it's silly code.
> 
> 
>> - sa = (cdbp[8] << 8) + cdbp[9];
>> + sa = be16_to_cpu(((struct scsi_varlen_cdb_hdr *)cdbp)->service_action);
> 
> Here, however, I find the original code far superior.  I know what
> you're doing and why but I find the old code a bazillion times easier to
> read.  Short and to the point.  No complex typecasts and I don't have to
> go hunting for varlen_cdb_hdr struct definitions.  I dive straight into
> SBC and see that bytes 8 and 9 in the CDB constitute the service action.
> Done!
> 

At least I can go hunting for varlen_cdb_hdr, which is a simple right-click,
ctags-lookup, and actually see the exact definition of the complete header.

With SBC I need to fire up acroread, search for the right section in a 500 pages
document and then start all these speculations of how a BE int in scsi is, first
byte need shifting, or the other way around.
And that is after I was able to register, pays large sums of money before I was
even able to read it. (And at the end produce code that in some systems is 90 times
slower, yes 90 times slower, ok for a be64)

Come on I give you the SBC on a silver plater, not in English, in C. And in the
same editor, and in git, already downloaded togther with your Kernel. You can't
really be serious about that. Except, that bad habits die hard.

> I know that the header looks the same for all variable length commands.
> But we don't have a struct scsi_cdb_header with an "operation code"
> entry pointing to cmnd[0] either.  Nor do we have headers for the
> MAINTENANCE and SERVICE ACTION commands.  To me a CDB is a byte stream
> and not a bunch of structs.
> 

Sure you do, why? just look harder it's there.
And, No it is not a stream by any definition of any language. Please?

Two lines up we are using scsi_varlen_cdb_length() which uses the same technic
so I thought it might be appropriate.

> Anyway.  I know where you stand on this :)
> 

That said, I know it's just a lost cause. At first I thought I should just ignore
it. But it's early in the morning, and before my first coffee, so I need to pick a
fight with someone... Thanks body ;)

> 
> scsi: Fix printing of variable length commands
> 
> We dereferenced the MAINTENANCE IN array when decoding variable length
> commands.  Use the right array.  Also consolidate identical if
> statements below.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 9129bcf..7092ff6 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -219,18 +219,15 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
>  			break;
>  		}
>  		sa = (cdbp[8] << 8) + cdbp[9];
> -		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
> -		if (name) {
> +		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
> +		if (name)
>  			printk("%s", name);
> -			if ((cdb_len > 0) && (len != cdb_len))
> -				printk(", in_cdb_len=%d, ext_len=%d",
> -				       len, cdb_len);
> -		} else {
> +		else
>  			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
> -			if ((cdb_len > 0) && (len != cdb_len))
> -				printk(", in_cdb_len=%d, ext_len=%d",
> -				       len, cdb_len);
> -		}
> +
> +		if ((cdb_len > 0) && (len != cdb_len))
> +			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
> +
>  		break;
>  	case MAINTENANCE_IN:
>  		sa = cdbp[1] & 0x1f;
> 

