From: Dave Jones <davej@redhat.com>
Subject: Re: [SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID
 Adapter Driver
Date: Wed, 4 Sep 2013 19:27:25 -0400
Message-ID: <20130904232725.GA5727@redhat.com>
References: <20130903233716.5333B660D6B@gitolite.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130903233716.5333B660D6B@gitolite.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, bgrove@attotech.com
List-Id: linux-scsi@vger.kernel.org

 > +struct esas2r_adapter {
 > +	struct esas2r_target targetdb[ESAS2R_MAX_TARGETS];
 > +	struct esas2r_target *targetdb_end;
 ... 
 > +	u8 fw_coredump_buff[ESAS2R_FWCOREDUMP_SZ];


 > +void esas2r_reset_chip(struct esas2r_adapter *a)
 > +{
 > +	if (!esas2r_is_adapter_present(a))
 > +		return;
 > +
 > +	/*
 > +	 * Before we reset the chip, save off the VDA core dump.  The VDA core
 > +	 * dump is located in the upper 512KB of the onchip SRAM.  Make sure
 > +	 * to not overwrite a previous crash that was saved.
 > +	 */
 > +	if ((a->flags2 & AF2_COREDUMP_AVAIL)
 > +	    && !(a->flags2 & AF2_COREDUMP_SAVED)
 > +	    && a->fw_coredump_buff) {
 > +		esas2r_read_mem_block(a,
 > +				      a->fw_coredump_buff,
 > +				      MW_DATA_ADDR_SRAM + 0x80000,
 > +				      ESAS2R_FWCOREDUMP_SZ);

Comparing an array (fw_coredump_buff) to null probably isn't what you intended here.

	Dave
