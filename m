From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 11:36:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204161736.g3GHaX992665@aslan.scsiguy.com>
References: <02Apr16.112509edt.119051@cyborg.cybernetics.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 16 Apr 2002 11:25:06 EDT."
             <02Apr16.112509edt.119051@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

>> > If you insist on doing this, lets at least preserve the current
>> > behavior:
>>
>> > 	/*
>> > 	 * FIXME: this driver treats deferred errors are fatal for
>> [...]
>> > 	if (scsi_sense_valid(SCpnt)
>> > 	 && scsi_sense_key(SCpnt) == SKEY_CURRENT_ERROR) {
>>
>> Excellent!  It's a lot more readable for people not versed in
>> sense buffer
>> layout, thanks!
>
>Why are you calling it the sense key?  Current vs. deferred error is
>indicated by the error code (sense_data[0] & 0x7f), not the sense key
>(sense_data[2] & 0x0f).  Calling it the sense key may lead to confusion for
>those who are versed in sense buffer layout.

Yes, my fault for typing something quickly.  If I were to propose anything
at all, it would be to follow the definitions I did for FreeBSD:

struct scsi_sense_data
{
	uint8_t error_code;
#define	SSD_ERRCODE			0x7F
#define		SSD_CURRENT_ERROR	0x70
#define		SSD_DEFERRED_ERROR	0x71
#define	SSD_ERRCODE_VALID	0x80	
	uint8_t segment;
	uint8_t flags;
#define	SSD_KEY				0x0F
#define		SSD_KEY_NO_SENSE	0x00
#define		SSD_KEY_RECOVERED_ERROR	0x01
#define		SSD_KEY_NOT_READY	0x02
#define		SSD_KEY_MEDIUM_ERROR	0x03
#define		SSD_KEY_HARDWARE_ERROR	0x04
#define		SSD_KEY_ILLEGAL_REQUEST	0x05
#define		SSD_KEY_UNIT_ATTENTION	0x06
#define		SSD_KEY_DATA_PROTECT	0x07
#define		SSD_KEY_BLANK_CHECK	0x08
#define		SSD_KEY_Vendor_Specific	0x09
#define		SSD_KEY_COPY_ABORTED	0x0a
#define		SSD_KEY_ABORTED_COMMAND	0x0b		
#define		SSD_KEY_EQUAL		0x0c
#define		SSD_KEY_VOLUME_OVERFLOW	0x0d
#define		SSD_KEY_MISCOMPARE	0x0e
#define		SSD_KEY_RESERVED	0x0f			
#define	SSD_ILI		0x20
#define	SSD_EOM		0x40
#define	SSD_FILEMARK	0x80
	uint8_t info[4];
	uint8_t extra_len;
	uint8_t cmd_spec_info[4];
	uint8_t add_sense_code;
	uint8_t add_sense_code_qual;
	uint8_t fru;
	uint8_t sense_key_spec[3];
#define	SSD_SCS_VALID		0x80
#define SSD_FIELDPTR_CMD	0x40
#define SSD_BITPTR_VALID	0x08
#define SSD_BITPTR_VALUE	0x07
#define SSD_MIN_SIZE 18
	uint8_t extra_bytes[14];
#define SSD_FULL_SIZE sizeof(struct scsi_sense_data)
};


static __inline void scsi_extract_sense(struct scsi_sense_data *sense,
					int *error_code, int *sense_key,
					int *asc, int *ascq);
static __inline void scsi_ulto2b(u_int32_t val, u_int8_t *bytes);
static __inline void scsi_ulto3b(u_int32_t val, u_int8_t *bytes);
static __inline void scsi_ulto4b(u_int32_t val, u_int8_t *bytes);
static __inline u_int32_t scsi_2btoul(u_int8_t *bytes);
static __inline u_int32_t scsi_3btoul(u_int8_t *bytes);
static __inline int32_t scsi_3btol(u_int8_t *bytes);
static __inline u_int32_t scsi_4btoul(u_int8_t *bytes);

static __inline void
scsi_ulto2b(u_int32_t val, u_int8_t *bytes)
{

	bytes[0] = (val >> 8) & 0xff;
	bytes[1] = val & 0xff;
}

static __inline void
scsi_ulto3b(u_int32_t val, u_int8_t *bytes)
{

	bytes[0] = (val >> 16) & 0xff;
	bytes[1] = (val >> 8) & 0xff;
	bytes[2] = val & 0xff;
}

static __inline void
scsi_ulto4b(u_int32_t val, u_int8_t *bytes)
{

	bytes[0] = (val >> 24) & 0xff;
	bytes[1] = (val >> 16) & 0xff;
	bytes[2] = (val >> 8) & 0xff;
	bytes[3] = val & 0xff;
}

static __inline u_int32_t
scsi_2btoul(u_int8_t *bytes)
{
	u_int32_t rv;

	rv = (bytes[0] << 8) |
	     bytes[1];
	return (rv);
}

static __inline u_int32_t
scsi_3btoul(u_int8_t *bytes)
{
	u_int32_t rv;

	rv = (bytes[0] << 16) |
	     (bytes[1] << 8) |
	     bytes[2];
	return (rv);
}

static __inline int32_t 
scsi_3btol(u_int8_t *bytes)
{
	u_int32_t rc = scsi_3btoul(bytes);
 
	if (rc & 0x00800000)
		rc |= 0xff000000;

	return (int32_t) rc;
}

static __inline u_int32_t
scsi_4btoul(u_int8_t *bytes)
{
	u_int32_t rv;

	rv = (bytes[0] << 24) |
	     (bytes[1] << 16) |
	     (bytes[2] << 8) |
	     bytes[3];
	return (rv);
}

static __inline void scsi_extract_sense(struct scsi_sense_data *sense,
					int *error_code, int *sense_key,
					int *asc, int *ascq)
{
	*error_code = sense->error_code & SSD_ERRCODE;
	*sense_key = sense->flags & SSD_KEY;
	*asc = (sense->extra_len >= 5) ? sense->add_sense_code : 0;
	*ascq = (sense->extra_len >= 6) ? sense->add_sense_code_qual : 0;
}

And corrected code in sd.c might look like this:

	if (driver_byte(result) != 0 &&
            scsi_sense_valid(SCpnt) &&
	    SCpnt->sense_buffer.error_code & SSD_ERRCODE_VALID) {
		int *error_code;
		int *sense_key;
		int *asc;
		int *ascq;
		
		scsi_extract_sense(&SCpnt->sense_buffer, &error_code,
				   &sense_key, &asc, &ascq);
		if (error_code == SSD_DEFERRED_ERROR)
			goto report_error_and_retry_command;

		if (error_code != SSD_CURRENT_ERROR)
			goto report_error_and_fail_command;

		switch (sense_key) {
		case MEDIUM_ERROR:
			error_sector = scsi_4btoul(SCpnt->sense_buffer.info);
			
etc.

This would make the code much more explicit.

--
Justin
