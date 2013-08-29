From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [RFC/PATCH 1/3] scsi: ufs: query descriptor API
Date: Thu, 29 Aug 2013 18:08:49 +0300
Message-ID: <00d001cea4c9$ad14db10$073e9130$@codeaurora.org>
References: <1377788353-5423-1-git-send-email-rshvili@codeaurora.org> <00ca01cea4c9$5798b350$06ca19f0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <00ca01cea4c9$5798b350$06ca19f0$@codeaurora.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Raviv Shvili' <rshvili@codeaurora.org>, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, 'Dolev Raviv' <draviv@codeaurora.org>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Yaniv Gardi
= > Sent: Thursday, August 29, 2013 6:06 PM
= > To: 'Raviv Shvili'; linux-scsi@vger.kernel.org
= > Cc: linux-arm-msm@vger.kernel.org; 'Dolev Raviv'; 'open list'
= > Subject: RE: [RFC/PATCH 1/3] scsi: ufs: query descriptor API
= > 
= > Looks good to me.
= > Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
= > 
= > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
= > member of Code Aurora Forum, hosted by The Linux Foundation
= > 
= > 
= > = > -----Original Message-----
= > = > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi- = >
= > owner@vger.kernel.org] On Behalf Of Raviv Shvili = > Sent: Thursday,
= > August 29, 2013 5:59 PM = > To: linux-scsi@vger.kernel.org = > Cc:
linux-
= > arm-msm@vger.kernel.org; Raviv Shvili; Dolev Raviv; open list = >
Subject:
= > [RFC/PATCH 1/3] scsi: ufs: query descriptor API = > = > Introduces the
API
= > for sending queries with descriptors.
= > = > A descriptor is a block or page of parameters that describe the
device.
= > = > The descriptors are classified into types and can range in size from
2
= > bytes = > through 255 bytes.
= > = > All descriptors have a length value as their first element, and a
type = >
= > identification element as their second byte.
= > = > All descriptors are readable and some may be write once.
= > = > They are accessed using their type, index and selector.
= > = >
= > = > Signed-off-by: Dolev Raviv <draviv@codeaurora.org> = >
Signed-off-by:
= > Raviv Shvili <rshvili@codeaurora.org> = > = > diff --git
= > a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index = >
= > bce09a6..202e15d 100644 = > --- a/drivers/scsi/ufs/ufs.h = > +++
= > b/drivers/scsi/ufs/ufs.h = > @@ -41,7 +41,8 @@ = >
= > = >  #define MAX_CDB_SIZE	16
= > = >  #define GENERAL_UPIU_REQUEST_SIZE 32
= > = > -#define QUERY_DESC_MAX_SIZE       256
= > = > +#define QUERY_DESC_MAX_SIZE       255
= > = > +#define QUERY_DESC_MIN_SIZE       2
= > = >  #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
= > = >  					(sizeof(struct
utp_upiu_header)))
= > = >
= > = > @@ -117,6 +118,20 @@ enum attr_idn {
= > = >  	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
= > = >  };
= > = >
= > = > +/* Descriptor idn for Query requests */ enum desc_idn {
= > = > +	QUERY_DESC_IDN_DEVICE		= 0x0,
= > = > +	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
= > = > +	QUERY_DESC_IDN_UNIT		= 0x2,
= > = > +	QUERY_DESC_IDN_RFU_0		= 0x3,
= > = > +	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
= > = > +	QUERY_DESC_IDN_STRING		= 0x5,
= > = > +	QUERY_DESC_IDN_RFU_1		= 0x6,
= > = > +	QUERY_DESC_IDN_GEOMETRY		= 0x7,
= > = > +	QUERY_DESC_IDN_POWER		= 0x8,
= > = > +	QUERY_DESC_IDN_RFU_2		= 0x9,
= > = > +};
= > = > +
= > = >  /* Exception event mask values */
= > = >  enum {
= > = >  	MASK_EE_STATUS		= 0xFFFF,
= > = > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index =
= > > b7d74bf..6da0d41 100644 = > --- a/drivers/scsi/ufs/ufshcd.c = > +++
= > b/drivers/scsi/ufs/ufshcd.c = > @@ -1118,6 +1118,31 @@ out_put_tag:
= > = >  }
= > = >
= > = >  /**
= > = > + * ufshcd_init_query() - init the query response and request
= > parameters = > + * @hba: per-adapter instance = > + * @request: address
= > of the request pointer to be initialized = > + * @response: address of
the
= > response pointer to be initialized = > + * @opcode: operation to perform
=
= > > + * @idn: flag idn to access = > + * @index: LU number to access = > +
*
= > @selector: query/flag/descriptor further identification  */ static = >
+inline
= > void ufshcd_init_query(struct ufs_hba *hba,
= > = > +		struct ufs_query_req **request, struct ufs_query_res
= > = > **response,
= > = > +		enum query_opcode opcode, enum attr_idn idn,
= > = > +		u8 index, u8 selector)
= > = > +{
= > = > +	*request = &hba->dev_cmd.query.request;
= > = > +	*response = &hba->dev_cmd.query.response;
= > = > +	memset(*request, 0, sizeof(struct ufs_query_req));
= > = > +	memset(*response, 0, sizeof(struct ufs_query_res));
= > = > +	(*request)->upiu_req.opcode = opcode;
= > = > +	(*request)->upiu_req.idn = idn;
= > = > +	(*request)->upiu_req.index = index;
= > = > +	(*request)->upiu_req.selector = selector; }
= > = > +
= > = > +/**
= > = >   * ufshcd_query_flag() - API function for sending flag query
requests
= > = >   * hba: per-adapter instance
= > = >   * query_opcode: flag query to perform
= > = > @@ -1129,17 +1154,15 @@ out_put_tag:
= > = >  static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode
= > = > opcode,
= > = >  			enum flag_idn idn, bool *flag_res)
= > = >  {
= > = > -	struct ufs_query_req *request;
= > = > -	struct ufs_query_res *response;
= > = > -	int err;
= > = > +	struct ufs_query_req *request = NULL;
= > = > +	struct ufs_query_res *response = NULL;
= > = > +	int err, index = 0, selector = 0;
= > = >
= > = >  	BUG_ON(!hba);
= > = >
= > = >  	mutex_lock(&hba->dev_cmd.lock);
= > = > -	request = &hba->dev_cmd.query.request;
= > = > -	response = &hba->dev_cmd.query.response;
= > = > -	memset(request, 0, sizeof(struct ufs_query_req));
= > = > -	memset(response, 0, sizeof(struct ufs_query_res));
= > = > +	ufshcd_init_query(hba, &request, &response, opcode, idn,
index,
= > = > +			selector);
= > = >
= > = >  	switch (opcode) {
= > = >  	case UPIU_QUERY_OPCODE_SET_FLAG:
= > = > @@ -1164,12 +1187,8 @@ static int ufshcd_query_flag(struct ufs_hba
= > = > *hba, enum query_opcode opcode,
= > = >  		err = -EINVAL;
= > = >  		goto out_unlock;
= > = >  	}
= > = > -	request->upiu_req.opcode = opcode;
= > = > -	request->upiu_req.idn = idn;
= > = >
= > = > -	/* Send query request */
= > = > -	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
= > = > -			QUERY_REQ_TIMEOUT);
= > = > +	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
= > = > QUERY_REQ_TIMEOUT);
= > = >
= > = >  	if (err) {
= > = >  		dev_err(hba->dev,
= > = > @@ -1201,8 +1220,8 @@ out_unlock:
= > = >  int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode
= > opcode,
= > = >  			enum attr_idn idn, u8 index, u8 selector,
u32
= > = > *attr_val)  {
= > = > -	struct ufs_query_req *request;
= > = > -	struct ufs_query_res *response;
= > = > +	struct ufs_query_req *request = NULL;
= > = > +	struct ufs_query_res *response = NULL;
= > = >  	int err;
= > = >
= > = >  	BUG_ON(!hba);
= > = > @@ -1215,10 +1234,8 @@ int ufshcd_query_attr(struct ufs_hba *hba,
= > = > enum query_opcode opcode,
= > = >  	}
= > = >
= > = >  	mutex_lock(&hba->dev_cmd.lock);
= > = > -	request = &hba->dev_cmd.query.request;
= > = > -	response = &hba->dev_cmd.query.response;
= > = > -	memset(request, 0, sizeof(struct ufs_query_req));
= > = > -	memset(response, 0, sizeof(struct ufs_query_res));
= > = > +	ufshcd_init_query(hba, &request, &response, opcode, idn,
index,
= > = > +			selector);
= > = >
= > = >  	switch (opcode) {
= > = >  	case UPIU_QUERY_OPCODE_WRITE_ATTR:
= > = > @@ -1235,14 +1252,7 @@ int ufshcd_query_attr(struct ufs_hba *hba,
= > = > enum query_opcode opcode,
= > = >  		goto out_unlock;
= > = >  	}
= > = >
= > = > -	request->upiu_req.opcode = opcode;
= > = > -	request->upiu_req.idn = idn;
= > = > -	request->upiu_req.index = index;
= > = > -	request->upiu_req.selector = selector;
= > = > -
= > = > -	/* Send query request */
= > = > -	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
= > = > -						QUERY_REQ_TIMEOUT);
= > = > +	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
= > = > QUERY_REQ_TIMEOUT);
= > = >
= > = >  	if (err) {
= > = >  		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d
failed,
= > = > err = %d\n", @@ -1259,6 +1269,82 @@ out:
= > = >  }
= > = >
= > = >  /**
= > = > + * ufshcd_query_descriptor - API function for sending descriptor =
>
= > +requests = > + * hba: per-adapter instance = > + * opcode: attribute
= > opcode = > + * idn: attribute idn to access = > + * index: index field =
> + *
= > selector: selector field = > + * desc_buf: the buffer that contains the
= > descriptor = > + * buf_len: length parameter passed to the device = > +
* =
= > > + * Returns 0 for success, non-zero in case of failure.
= > = > + * The buf_len parameter will contain, on return, the length
parameter
= > = > + * received on the response.
= > = > + */
= > = > +int ufshcd_query_descriptor(struct ufs_hba *hba,
= > = > +			enum query_opcode opcode, enum attr_idn idn,
u8
= > = > index,
= > = > +			u8 selector, u8 *desc_buf, int *buf_len) {
= > = > +	struct ufs_query_req *request = NULL;
= > = > +	struct ufs_query_res *response = NULL;
= > = > +	int err;
= > = > +
= > = > +	BUG_ON(!hba);
= > = > +
= > = > +	if (!desc_buf) {
= > = > +		dev_err(hba->dev, "%s: descriptor buffer required
for
= > = > opcode 0x%x\n",
= > = > +				__func__, opcode);
= > = > +		err = -EINVAL;
= > = > +		goto out;
= > = > +	}
= > = > +
= > = > +	if (*buf_len <= QUERY_DESC_MIN_SIZE || *buf_len >
= > = > QUERY_DESC_MAX_SIZE) {
= > = > +		dev_err(hba->dev, "%s: descriptor buffer size (%d)
is out of
= > = > range\n",
= > = > +				__func__, *buf_len);
= > = > +		err = -EINVAL;
= > = > +		goto out;
= > = > +	}
= > = > +
= > = > +	mutex_lock(&hba->dev_cmd.lock);
= > = > +	ufshcd_init_query(hba, &request, &response, opcode, idn,
index,
= > = > +			selector);
= > = > +	hba->dev_cmd.query.descriptor = desc_buf;
= > = > +	request->upiu_req.length = *buf_len;
= > = > +
= > = > +	switch (opcode) {
= > = > +	case UPIU_QUERY_OPCODE_WRITE_DESC:
= > = > +		request->query_func =
= > = > UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
= > = > +		break;
= > = > +	case UPIU_QUERY_OPCODE_READ_DESC:
= > = > +		request->query_func =
= > = > UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
= > = > +		break;
= > = > +	default:
= > = > +		dev_err(hba->dev,
= > = > +				"%s: Expected query descriptor
opcode but
= > = > got = 0x%.2x\n",
= > = > +				__func__, opcode);
= > = > +		err = -EINVAL;
= > = > +		goto out_unlock;
= > = > +	}
= > = > +
= > = > +	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
= > = > QUERY_REQ_TIMEOUT);
= > = > +
= > = > +	if (err) {
= > = > +		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d
failed,
= > = > err = %d\n",
= > = > +				__func__, opcode, idn, err);
= > = > +		goto out_unlock;
= > = > +	}
= > = > +
= > = > +	hba->dev_cmd.query.descriptor = NULL;
= > = > +	*buf_len = response->upiu_res.length;
= > = > +
= > = > +out_unlock:
= > = > +	mutex_unlock(&hba->dev_cmd.lock);
= > = > +out:
= > = > +	return err;
= > = > +}
= > = > +
= > = > +/**
= > = >   * ufshcd_memory_alloc - allocate memory for host memory space
= > data
= > = > structures
= > = >   * @hba: per adapter instance
= > = >   *
= > = > --
= > = > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
= > = > is a member of Code Aurora Forum, hosted by The Linux Foundation = >
= > = > -- = > To unsubscribe from this list: send the line "unsubscribe
linux-scsi"
= > in the = > body of a message to majordomo@vger.kernel.org More
= > majordomo info = > at  http://vger.kernel.org/majordomo-info.html
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html
